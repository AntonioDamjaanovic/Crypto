//
//  Endpoint.swift
//  Crypto
//
//  Created by Antonio Damjanović on 30.10.2026..
//

import Foundation

enum Endpoint {
    case markets(vsCurrency: String, page: Int = 1, perPage: Int = 50)
    case coinDetail(id: String)
    
    private var path: String {
        switch self {
            case .markets:
                return "/coins/markets"
            case .coinDetail(let id):
                return "/coins/\(id)"
        }
    }
    
    private var querryItems: [URLQueryItem] {
        switch self {
            case .markets(let vsCurrency, let page, let perPage):
                return [
                    URLQueryItem(name: "vs_currency", value: vsCurrency),
                    URLQueryItem(name: "order", value: "market_cap_desc"),
                    URLQueryItem(name: "per_page", value: String(perPage)),
                    URLQueryItem(name: "page", value: String(page))
                ]
            case .coinDetail(_):
                return []
            }
    }
    
    func urlRequest(config: APIConfig) throws -> URLRequest {
        var components = URLComponents(url: config.baseURL, resolvingAgainstBaseURL: false)
        components?.path += path
        components?.queryItems = querryItems.isEmpty ? nil : querryItems
        
        guard let url = components?.url else { throw APIError.invalidURL }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "accept")
        request.setValue(config.apiKey, forHTTPHeaderField: "x-cg-demo-api-key")
        
        return request
    }
}
