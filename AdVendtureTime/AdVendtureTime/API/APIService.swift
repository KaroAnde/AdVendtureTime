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
    
    func fetchAds() -> AnyPublisher<AdData, Error> {
        guard let url = URL(string: APIConfig.baseURL) else {
            return Fail(error: RequestError.invalidURL)
                .eraseToAnyPublisher()
        }
        return URLSession.shared.dataTaskPublisher(for: url).tryMap { data, response in
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
