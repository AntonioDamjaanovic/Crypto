//
//  SortOption.swift
//  Crypto
//
//  Created by Antonio Damjanović on 02.11.2026..
//

import Foundation

enum SortOption: String, CaseIterable, Identifiable {
    case marketCap
    case price
    case change
    case name
    var id: Self { self }
    
    var title: String {
        switch self {
            case .marketCap:
                "Market Cap"
            case .price:
                "Price"
            case .change:
                "24h change"
            case .name:
                "Name"
        }
    }
}
