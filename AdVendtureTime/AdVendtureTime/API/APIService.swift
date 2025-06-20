//
//  APIService.swift
//  AdVendtureTime
//
//  Created by Karoline Skumsrud Andersen on 20/06/2025.
//
import Foundation
import Combine

class APIService {
    static let shared = APIService()
    private let session: NetworkSession
    private let baseURL: String
    
    init(session: NetworkSession = URLSession.shared, baseURL: String = APIConfig.baseURL) {
        self.session = session
        self.baseURL = baseURL
    }
    
    func fetchAds() -> AnyPublisher<AdData, Error> {
        guard let url = URL(string: baseURL) else {
            return Fail(error: RequestError.invalidURL)
                .eraseToAnyPublisher()
        }
        return session.urlTaskPublisher(for: url).tryMap { data, response in
            guard let httpResponse = response as? HTTPURLResponse else {
                throw RequestError.invalidResponse
            }
            
            guard (200..<300).contains(httpResponse.statusCode) else {
                throw RequestError.statusCode(code: httpResponse.statusCode, response: httpResponse, data: data)
            }
            
            return data
        }
        .decode(type: AdData.self, decoder: JSONDecoder())
        .eraseToAnyPublisher()
    }
}
