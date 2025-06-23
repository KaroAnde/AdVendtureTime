//
//  MockFavouritesService.swift
//  AdVendtureTime
//
//  Created by Karoline Skumsrud Andersen on 23/06/2025.
//

import Combine
import Foundation

final class MockFavouritesService: FavouritesPersistenceServiceProtocol {
    private(set) var items: [AdItem]
    var pathUrl: URL = URL(fileURLWithPath: "mock/path/VendAdItem.json")
    
    init(items: [AdItem]) {
        self.items = items
    }
    
    func readFromFavouriteAdItems() -> AnyPublisher<[AdItem],Error> {
        Just(items)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func writeToFavouriteAdItems(items: [AdItem]) -> AnyPublisher<URL,Error> {
        self.items = items
        return Just(pathUrl)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func updateFavouriteAdItems(favouriteAds: [AdItem]) -> AnyPublisher<URL,Error> {
        var updated = items
        let toRemove = favouriteAds
            .filter { !$0.isFavourite }
            .map(\.id)
        updated.removeAll { toRemove.contains($0.id) }
        
        let toAdd = favouriteAds.filter {
            $0.isFavourite && !updated.contains(where: { $0.id == $0.id })
        }
        updated.append(contentsOf: toAdd)
        
        self.items = updated
        return Just(pathUrl)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
