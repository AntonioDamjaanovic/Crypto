//
//  CoinRepository.swift
//  Crypto
//
//  Created by Antonio Damjanović on 30.10.2026..
//

import Foundation
import Combine

protocol CoinRepository {
    func fetchCoins(vsCurrency: String, page: Int, perPage: Int) -> AnyPublisher<[Coin], APIError>
}
