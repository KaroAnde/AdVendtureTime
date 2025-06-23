//
//  URLSession + NetworkSession.swift
//  AdVendtureTime
//
//  Created by Karoline Skumsrud Andersen on 20/06/2025.
//

import Foundation
import Combine

extension URLSession: NetworkSession {
    func urlTaskPublisher(for url: URL) -> AnyPublisher<(data: Data, response: URLResponse), RequestError> {
        self.dataTaskPublisher(for: url)
            .mapError { error in
            switch error.code {
            case .badURL:
                return .invalidURL
            case .notConnectedToInternet:
                return .notConnectedToInternet
            case .timedOut:
                return .timedOut
            case .networkConnectionLost:
                return .networkConnectionLost
            case .unsupportedURL:
                return .unsupportedURL
            default:
                return .underlyingError
            }
        }
        .eraseToAnyPublisher()
    }
}
