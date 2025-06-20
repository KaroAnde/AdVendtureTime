//
//  RequestError.swift
//  AdVendtureTime
//
//  Created by Karoline Skumsrud Andersen on 20/06/2025.
//
import Foundation

public enum RequestError: Error, CustomDebugStringConvertible {
    case invalidURL
    case decoding(error: DecodingError, data: Data)
    case statusCode(code: Int, response: HTTPURLResponse, data: Data)
    case invalidResponse
    
    public var debugDescription: String {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .decoding(let error, let data):
            return [String(describing: error), String(data: data, encoding: .utf8).map { "JSON: { \($0)"}]
                .compactMap { $0 }
                .joined(separator: ", ")
        case .statusCode(let code, let response, let data):
            return ["Status code: \(code)", response.description, String(data: data, encoding: .utf8).map { "JSON: \($0)" }]
                .compactMap { $0 }
                .joined(separator: ", ")
        case .invalidResponse:
            return "Can not cast to HTTPURLResponse"
        }
    }
}
