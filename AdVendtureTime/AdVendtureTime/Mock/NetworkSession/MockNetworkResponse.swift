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

struct MockAdData {
    let mockType: MockAdDataType
    
    
    init(mockType: MockAdDataType) {
        self.mockType = mockType
    }
    
    var data: Data {
        switch mockType {
        case .nonNilValuesMock:
            return Data(MockAdDataJson.adDataJsonAllvalues.utf8)
        case .nilValuesMock:
            return Data(MockAdDataJson.adDataJsonNilValues.utf8)
        }
    }
    
    var response: URLResponse { HTTPURLResponse(
        url: URL(string: "https://vend.com")!,
        statusCode: 200,
        httpVersion: nil,
        headerFields: nil)!
    }
    
    func mockService() -> APIService {
        let mockSession = MockNetworkSession()
        mockSession.result = .success(data: data, response: response)
        return APIService(session: mockSession)
    }
}

enum MockAdDataType {
    case nonNilValuesMock
    case nilValuesMock
}
