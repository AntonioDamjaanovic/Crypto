//
//  CoinRowView.swift
//  Crypto
//
//  Created by Antonio Damjanović on 30.10.2026..
//

import SwiftUI

struct CoinRowView: View {
    let coin: Coin
    
    var body: some View {
        HStack {
            Text("\(coin.marketCapRank)")
                .foregroundStyle(.secondary)
                .font(.callout)
            
            CoinImageView(url: coin.image)
                .frame(width: 30, height: 30)
                .padding(.leading, 10)
            
            Text(coin.symbol.uppercased())
                .font(.title2.bold())
            
            Spacer()
            
            VStack {
                Text("$\(coin.currentPrice.formatted())")
                    .foregroundStyle(.primary)
                    .font(.title3)
                
                Text(coin.priceChangePercentage24H / 100, format: .percent.precision(.fractionLength(2)))
                    .foregroundStyle(coin.currentPrice >= 0 ? .green : .pink)
            }
        }
    }
}

#Preview {
    CoinRowView(coin: .example)
}
