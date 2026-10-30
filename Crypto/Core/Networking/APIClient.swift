//
//  APIClient.swift
//  Crypto
//
//  Created by Antonio Damjanović on 30.10.2026..
//

import Foundation
import Combine

final class APIClient {
    private let session: URLSession
    private let config: APIConfig
    private let decoder: JSONDecoder
    
    init(session: URLSession = .shared, config: APIConfig = .live) {
        self.session = session
        self.config = config
        self.decoder = JSONDecoder()
        self.decoder.keyDecodingStrategy = .convertFromSnakeCase
    }
    
    func request<T: Decodable>(_ endpoint: Endpoint, as type: T.Type) -> AnyPublisher<T, APIError> {
        let request: URLRequest
        do {
            request = try endpoint.urlRequest(config: config)
        } catch {
            return Fail(error: .invalidURL).eraseToAnyPublisher()
        }
        
        return session.dataTaskPublisher(for: request)
            .mapError { APIError.networkError($0) }
            .handleEvents(receiveOutput: { data, response in
                    if let http = response as? HTTPURLResponse {
                        print("Status:", http.statusCode)
                    }
                    print("Body:", String(data: data, encoding: .utf8) ?? "<non-utf8>")
                })
            .tryMap { data, response in
                guard let http = response as? HTTPURLResponse else { throw APIError.invalidURL }
                guard (200..<300).contains(http.statusCode) else { throw APIError.invalidResponse }
                return data
            }
            .decode(type: T.self, decoder: decoder)
            .mapError { error in
                (error as? APIError) ?? .decoding(error)
            }
            .eraseToAnyPublisher()
    }
}
