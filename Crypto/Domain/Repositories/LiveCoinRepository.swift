//
//  LiveCoinRepository.swift
//  Crypto
//
//  Created by Antonio Damjanović on 30.10.2026..
//

import Foundation
import Combine

final class LiveCoinRepository: CoinRepository {
    private let api: APIClient
    
    init(api: APIClient) {
        self.api = api
    }
    
    func fetchCoins(vsCurrency: String = "usd", page: Int = 1, perPage: Int = 50) -> AnyPublisher<[Coin], APIError> {
        api.request(.markets(vsCurrency: vsCurrency, page: page, perPage: perPage), as: [Coin].self)
            .eraseToAnyPublisher()
    }
}

import Playgrounds

#Playground {
    let repo = LiveCoinRepository(api: APIClient())

    var coins: [Coin] = []
    do {
        for try await batch in repo.fetchCoins().values {
            coins = batch
        }
    } catch {
        print("Error:", error.localizedDescription)
    }

    let count = coins.count
    let firstThree = Array(coins.prefix(3))
}
