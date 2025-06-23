//
//  FavouriteTests.swift
//  AdVendtureTime
//
//  Created by Karoline Skumsrud Andersen on 23/06/2025.
//

import XCTest
import Combine
@testable import AdVendtureTime

final class FavouriteTests: XCTestCase {
    var mockService: MockFavouritesService = MockFavouritesService(items: AdItem.mockList)
    var cancellables = Set<AnyCancellable>()
    
    lazy var repository: VendAdRepository = {
        VendAdRepository(favouritesService: mockService)
    }()
    
    deinit {
        cancellables.forEach { $0.cancel() }
    }
    
    func testFetchData() {
        let expecation = expectation(description: "read items")
        
        var result: [AdItem]?
        
        mockService.readFromFavouriteAdItems()
            .sink(receiveCompletion: { _ in },
                  receiveValue: { items in
                result = items
                expecation.fulfill()
            })
            .store(in: &cancellables)
        
        wait(for: [expecation], timeout: 1)
        
        XCTAssertEqual(result?.count, 3)
        XCTAssertEqual(result?.map { $0.id }, ["1", "2", "3"])
    }
    
}
