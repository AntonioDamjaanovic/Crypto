//
//  CoinListViewModel.swift
//  Crypto
//
//  Created by Antonio Damjanović on 30.10.2026..
//

import Foundation
import Combine

final class CoinListViewModel: ObservableObject {
    
    // MARK: Inputs
    @Published var searchText = ""
    @Published var sortOption: SortOption = .marketCap
    @Published var currency = "usd"
    
    // MARK: Outputs
    @Published private(set) var coins: [Coin] = []
    @Published private(set) var state: LoadingState = .idle
    @Published private(set) var isLoadingMore = false
    
    // MARK: Private variables
    private let repository: CoinRepository
    private let allCoins = CurrentValueSubject<[Coin], Never>([])
    private let refreshTrigger = PassthroughSubject<Void, Never>()
    private var cancellables = Set<AnyCancellable>()
    private static let pageSize = 50
    private var page = 1
    private var canLoadMore = true
    private var loadMoreCancellable: AnyCancellable?
    
    init(repository: CoinRepository = LiveCoinRepository(api: APIClient())) {
        self.repository = repository
        bindFetching()
        bindFiltering()
    }
    
    func refresh() {
        refreshTrigger.send()
    }
    
    // MARK: Fetching
    private func bindFetching() {
        Publishers.CombineLatest(
            $currency.removeDuplicates(),
            refreshTrigger.prepend(())
        )
        .receive(on: DispatchQueue.main)
        .handleEvents(receiveOutput: { [weak self] _ in
            guard let self else { return }
            self.loadMoreCancellable = nil
            self.isLoadingMore = false
            self.page = 1
            self.canLoadMore = true
            self.state = .loading
        })
        .map { [repository] currency, _ in
            repository.fetchCoins(vsCurrency: currency, page: 1, perPage: Self.pageSize)
                .map { Result<[Coin], APIError>.success($0) }
                .catch { Just(Result<[Coin], APIError>.failure($0)) }
        }
        .switchToLatest()
        .receive(on: DispatchQueue.main)
        .sink { [weak self] result in
            guard let self else { return }
            switch result {
                case .success(let coins):
                    self.allCoins.send(coins)
                    self.canLoadMore = coins.count == Self.pageSize
                    self.state = .loaded
                case .failure(let error):
                    self.state = .failed(error.localizedDescription)
            }
        }
        .store(in: &cancellables)
    }
    
    private func bindFiltering() {
        let query = $searchText
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .prepend("")
            .removeDuplicates()
        
        Publishers.CombineLatest3(allCoins, query, $sortOption)
            .map { coins, query, sort in
                Self.filterAndSort(coins, query: query, sort: sort)
            }
            .receive(on: DispatchQueue.main)
            .assign(to: &$coins)
    }
    
    private static func filterAndSort(_ coins: [Coin], query: String, sort: SortOption) -> [Coin] {
        let trimmed = query.trimmingCharacters(in: .whitespaces)
        let filtered = trimmed.isEmpty ? coins : coins.filter {
            $0.name.localizedCaseInsensitiveContains(trimmed) ||
            $0.symbol.localizedCaseInsensitiveContains(trimmed)
        }
        
        switch sort {
            case .marketCap: return filtered.sorted { $0.marketCapRank < $1.marketCapRank }
            case .price: return filtered.sorted { $0.currentPrice > $1.currentPrice }
            case .change: return filtered.sorted { $0.priceChange > $1.priceChange }
            case .name: return filtered.sorted { $0.name < $1.name }
        }
    }
    
    func loadMoreIfNeeded(currentCoin coin: Coin) {
        guard case .loaded = state,
              canLoadMore,
              !isLoadingMore,
              searchText.isEmpty,
              let index = coins.firstIndex(where: { $0.id == coin.id }),
              index >= coins.count - 10
        else { return }

        loadNextPage()
    }
    
    private func loadNextPage() {
        isLoadingMore = true
        let nextpage = page + 1
        
        loadMoreCancellable = repository
            .fetchCoins(vsCurrency: currency, page: nextpage, perPage: Self.pageSize)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoadingMore = false
            } receiveValue: { [weak self] newCoins in
                guard let self else { return }
                self.page = nextpage
                self.canLoadMore = newCoins.count == Self.pageSize
                
                let existingIDs = Set(self.allCoins.value.map(\.id))
                let unique = newCoins.filter { !existingIDs.contains($0.id) }
                self.allCoins.send(self.allCoins.value + unique)
            }
    }
}
