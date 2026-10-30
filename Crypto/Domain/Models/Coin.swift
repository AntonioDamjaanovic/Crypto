//
//  Coin.swift
//  Crypto
//
//  Created by Antonio Damjanović on 30.10.2026..
//

import Foundation

struct Coin: Decodable, Identifiable {
    let id: String
    let symbol: String
    let name: String
    let image: String
    let currentPrice: Double
    let marketCap: Double
    
    static var example: Coin {
        return Coin(id: "bitcoin", symbol: "btc", name: "Bitcoin", image: "https://coin-images.coingecko.com/coins/images/1/large/bitcoin.png?1696501400", currentPrice: 77671, marketCap: 1555886872303)
    }
}
