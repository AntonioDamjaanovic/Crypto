//
//  LoadingState.swift
//  Crypto
//
//  Created by Antonio Damjanović on 30.10.2026..
//

import Foundation

enum LoadingState: Equatable {
    case idle
    case loading
    case loaded
    case failed(String)
    
    var isLoading: Bool {
        if case .loading = self { return true }
        return false
    }
    
    var data: Bool {
        if case .loaded = self { return true }
        return false
    }
    
    var failed: String? {
        if case .failed(let message) = self { return message }
        return nil
    }
}
