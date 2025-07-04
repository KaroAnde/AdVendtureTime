//
//  MockNetworkSession.swift
//  AdVendtureTime
//
//  Created by Karoline Skumsrud Andersen on 20/06/2025.
//

import Foundation
import Combine

class MockNetworkSession: NetworkSession {
    var result: MockNetworkResponse?
    var error: RequestError?
    
    func urlTaskPublisher(for url: URL) -> AnyPublisher<(data: Data, response: URLResponse), RequestError> {
        switch result {
        case .success(let data, let response):
            return Just((data: data, response: response))
                .setFailureType(to: RequestError.self)
                .eraseToAnyPublisher()
        case .failure(let failure):
            return Fail(error: failure)
                .eraseToAnyPublisher()
        case .none:
            return Fail(error: .underlyingError)
                .eraseToAnyPublisher()
        }
    }
}
