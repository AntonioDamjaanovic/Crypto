//
//  CoinListView.swift
//  Crypto
//
//  Created by Antonio Damjanović on 30.10.2026..
//

import SwiftUI

struct CoinListView: View {
    
    let coins: [Coin] = [.example, .example, .example]
    @State private var searchText = ""
    
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
        
        
        List(coins) { coin in
            NavigationLink(value: coin) {
                CoinRowView(coin: coin)
                    .padding(.vertical, 5)
            }
        }
        .navigationTitle("Market")
        .searchable(text: $searchText, placement: .automatic, prompt: "Search coins")
        .listStyle(.inset)
    }
}

#Preview {
    NavigationStack {
        CoinListView()
    }
}
