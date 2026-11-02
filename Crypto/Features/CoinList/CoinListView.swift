//
//  CoinListView.swift
//  Crypto
//
//  Created by Antonio Damjanović on 30.10.2026..
//

import SwiftUI

struct CoinListView: View {
    
    @StateObject private var viewModel: CoinListViewModel
    
    init() {
        _viewModel = StateObject(wrappedValue: CoinListViewModel())
    }
    
    var body: some View {
        Group {
            switch viewModel.state {
                case .idle,
                        .loading where viewModel.coins.isEmpty:
                        ProgressView()
                    
                case .failed(let message) where viewModel.coins.isEmpty:
                    ContentUnavailableView("Couldn't load", systemImage: "wifi.slash", description: Text(message))
                
                default:
                    CoinList(viewModel: viewModel)
            }
        }
        .navigationTitle("Market")
        .searchable(text: $viewModel.searchText, placement: .automatic, prompt: "Search coins")
    }
}

private struct CoinList: View {
    
    @ObservedObject private var viewModel: CoinListViewModel
    
    init(viewModel: CoinListViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        HStack {
            Text("Coin")
            
            Spacer()
            
            Text("Price")
            
            Button {
                // TODO: refresh coins
            } label: {
                Image(systemName: "arrow.clockwise.circle")
            }
        }
        .foregroundStyle(.secondary)
        .font(.subheadline)
        .padding(.horizontal, 30)
        
        List(viewModel.coins) { coin in
            NavigationLink(value: coin) {
                CoinRowView(coin: coin)
                    .padding(.vertical, 5)
            }
        }
        .listStyle(.inset)
    }
}

#Preview {
    NavigationStack {
        CoinListView()
    }
}
