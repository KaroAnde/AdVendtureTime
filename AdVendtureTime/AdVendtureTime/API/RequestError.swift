//
//  RequestError.swift
//  AdVendtureTime
//
//  Created by Karoline Skumsrud Andersen on 20/06/2025.
//
import Foundation

public enum RequestError: Error, CustomDebugStringConvertible, Equatable {
    // URL-Errors
    case invalidURL
    case notConnectedToInternet
    case networkConnectionLost
    case timedOut
    
    // Request error
    case decoding(error: DecodingError, data: Data)
    case statusCode(code: Int, response: HTTPURLResponse, data: Data)
    case invalidResponse
    case underlyingError
    
    public static func == (lhs: RequestError, rhs: RequestError) -> Bool {
        lhs.type == rhs.type
    }
    
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
        case .underlyingError:
            return "Underlying error"
        case .notConnectedToInternet:
            return "Not connected to internet"
        case .networkConnectionLost:
            return "NetworkConnectionLost"
        case .timedOut:
            return "Session timed out"
        }
    }
    
    var type: RequestErrorType {
        switch self {
        case .invalidURL:
            return .invalidURL
        case .decoding:
            return .decoding
        case .statusCode:
            return .statusCode
        case .invalidResponse:
            return .invalidResponse
        case .underlyingError:
            return .underlyingError
        case .notConnectedToInternet:
            return .notConnectedToInternet
        case .networkConnectionLost:
            return .networkConnectionLost
        case .timedOut:
            return .timedOut
        }
    }
}

enum RequestErrorType {
    // URL-Errors
    case invalidURL
    case notConnectedToInternet
    case networkConnectionLost
    case timedOut
    
    // Request error
    case decoding
    case statusCode
    case invalidResponse
    case underlyingError
}
