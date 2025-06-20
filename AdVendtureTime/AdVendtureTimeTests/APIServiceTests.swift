//
//  APITests.swift
//  AdVendtureTime
//
//  Created by Karoline Skumsrud Andersen on 20/06/2025.
//

import XCTest
import Combine
@testable import AdVendtureTime

final class APIServiceTests: XCTestCase {
    var cancellables = Set<AnyCancellable>()
    let mockSession = MockNetworkSession()
    let adDataJsonAllValues = MockAdDataJson.adDataJsonAllvalues
    let adDataJsonNilValues = MockAdDataJson.adDataJsonNilValues
    
    
    func testFetchAdDataReturnsDecodedData() {
        let data = Data(adDataJsonAllValues.utf8)
        
        let response: URLResponse = HTTPURLResponse(
            url: URL(string: "https://vend.com")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )!
        
        mockSession.result = .success(data: data, response: response)
    
        let apiService = APIService(session: mockSession)
        
        let expectation = self.expectation(description: "Expected to decode and return AdData")
        
        apiService.fetchAds()
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTFail("Expected success but got error: \(error)")
                }
            }, receiveValue: { adData in
                XCTAssertEqual(adData.items.count, 3)
                XCTAssertEqual(adData.items[0].title, "Innholdsrikt rekkehus over tre plan med fin beliggenhet | Terrasse, hage og garasje")
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testUnsupportedUrl() {
        let apiService = APIService(baseURL: "not an url at all")
        let expectation = self.expectation(description: "Expected to get invalidUrl error")
        
        apiService.fetchAds().sink(receiveCompletion: { completion in
            if case .failure(let error as RequestError) = completion {
                XCTAssertEqual(error, .unsupportedURL)
                    expectation.fulfill()
                } else {
                    XCTFail("Should have given error invalidURL, but got \(completion)")
                }
        }, receiveValue: { _ in})
        .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testNotConnectedToInternet() {
        mockSession.result = .failure(.notConnectedToInternet)
        let apiService = APIService(session: mockSession)
        let expectation = self.expectation(description: "Expected to not be connected to internet")
        
        apiService.fetchAds().sink(receiveCompletion: { completion in
            if case .failure(let error as RequestError) = completion {
                XCTAssertEqual(error, .notConnectedToInternet)
                expectation.fulfill()
            } else {
                XCTFail("Should have given error notConnectedToInternet, but got \(completion)")
            }
        }, receiveValue: { _ in})
        .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testNetworkConnectionLost() {
        mockSession.result = .failure(.networkConnectionLost)
        let apiService = APIService(session: mockSession)
        let expectation = self.expectation(description: "Expected to lose network connection")
        
        apiService.fetchAds().sink(receiveCompletion: { completion in
            if case .failure(let error as RequestError) = completion {
                XCTAssertEqual(error, .networkConnectionLost)
                expectation.fulfill()
            } else {
                XCTFail("Should have given error notConnectedToInternet, but got \(completion)")
            }
        }, receiveValue: { _ in})
        .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)
    }
}
