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
                Text(coin.currentPrice.priceText())
                    .foregroundStyle(.primary)
                    .font(.title3)
                    .monospacedDigit()
                
                Text(coin.priceChange / 100, format: .percent.precision(.fractionLength(2)))
                    .foregroundStyle(coin.priceChange >= 0 ? .green : .pink)
            }
        }
    }
}

extension Double {
    func priceText(currencyCode: String = "USD") -> String {
        let digits: ClosedRange<Int>
        switch abs(self) {
            case 1000...: digits = 0...2
            case 1...: digits = 2...2
            case 0.01...: digits = 2...4
            default: digits = 2...8
        }
        return self.formatted(
            .currency(code: currencyCode)
                .precision(.fractionLength(digits))
        )
    }
}

#Preview {
    CoinRowView(coin: .example)
}
