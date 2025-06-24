//
//  NetworkSession.swift
//  AdVendtureTime
//
//  Created by Karoline Skumsrud Andersen on 20/06/2025.
//
import Combine
import Foundation

// protocol for taskpublisher to be able to mock and test
protocol NetworkSession {
    func urlTaskPublisher(for url: URL) -> AnyPublisher<(data: Data, response: URLResponse), RequestError>
}
