//
//  MockNetworkResponse.swift
//  AdVendtureTime
//
//  Created by Karoline Skumsrud Andersen on 20/06/2025.
//
import Foundation

enum MockNetworkResponse {
    case success(data: Data, response: URLResponse)
    case failure(RequestError)
}
