//
//  Secrets.swift
//  Crypto
//
//  Created by Antonio Damjanović on 30.10.2026..
//

import Foundation

enum Secrets {
    static var coinGeckoKey: String {
        Bundle.main.object(forInfoDictionaryKey: "CoinGeckoAPIKey") as? String ?? ""
    }
}
