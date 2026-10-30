//
//  APIConfig.swift
//  Crypto
//
//  Created by Antonio Damjanović on 30.10.2026..
//

import Foundation

struct APIConfig {
    let baseURL: URL
    let apiKey: String
    
    static let live = APIConfig(
        baseURL: URL(string: "https://api.coingecko.com/api/v3")!,
        apiKey: Secrets.coinGeckoKey
    )
}
