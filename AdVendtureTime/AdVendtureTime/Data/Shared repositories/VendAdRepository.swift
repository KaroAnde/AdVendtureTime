//
//  AdDashboardRepository.swift
//  AdVendtureTime
//
//  Created by Karoline Skumsrud Andersen on 22/06/2025.
//

import Combine
import Foundation

/// This repository handles transforming data from the service layer, and also handles merging of data from api and filemanager
protocol VendAdRepositoryProtocol {
    func getAds() -> AnyPublisher<[AdItem], Error>
    func updateAndReadFavouriteItems(favouriteAd: AdItem) -> AnyPublisher<[AdItem], Error>
    func updateFavourites(newFavouriteAd: AdItem) -> AnyPublisher<URL, Error>
    func fetchAdsFromFile() -> AnyPublisher<[AdItem], Error>
}

class VendAdRepository: VendAdRepositoryProtocol {
    let apiService: APIService
    let favouritesService: FavouritesPersistenceServiceProtocol
    
    init(apiService: APIService = APIService.shared, favouritesService: FavouritesPersistenceServiceProtocol = FavouritesPersistenceService()) {
        self.apiService = apiService
        self.favouritesService = favouritesService
    }
    
    // Merge data from api and filemanager as the DTO does not have isFavourite field
    func getAds() -> AnyPublisher<[AdItem], Error> {
        let apiAds = apiService.fetchAds().map { ads in
            ads.items.map { adItem in
                AdItem(item: adItem,
                       priceValue: adItem.price?.value,
                       shippingOption: adItem.shippingOption?.label,
                       isFavourite: false,
                       fullImageURL: adItem.fullImageURL,
                       localImageFileName: nil)
            }
        }
        
        let favourites = self.fetchAdsFromFile()
            .prepend([])
            .eraseToAnyPublisher()
        
        return Publishers.CombineLatest(apiAds, favourites).map { remoteAds, savedFavourites in
            let favouriteIds = Set(savedFavourites.map { $0.id })
                return remoteAds.map { remote in
                    let updated = remote
                    updated.isFavourite = favouriteIds.contains(remote.id)
                    return updated
                }
        }.eraseToAnyPublisher()
    }
    
    func updateFavourites(newFavouriteAd: AdItem) -> AnyPublisher<URL, Error>{
        favouritesService
            .updateFavouriteAdItems(favouriteAds: [newFavouriteAd])
            .eraseToAnyPublisher()
    }
    
    func fetchAdsFromFile() -> AnyPublisher<[AdItem], Error> {
        favouritesService
            .readFromFavouriteAdItems()
            .map { items in
                guard let documentsURL = FileManager.default
                    .urls(for: .documentDirectory, in: .userDomainMask)
                    .first else {
                    return items
                }
                
                let imagesFolder = documentsURL
                    .appendingPathComponent("VendAdImages", isDirectory: true)

                return items.map { item in
                    if let filename = item.localImageFileName {
                        let localURL = imagesFolder.appendingPathComponent(filename)
                        item.fullImageURL = localURL
                    }
                    return item
                }
            }
            .eraseToAnyPublisher()
    }
    func updateAndReadFavouriteItems(favouriteAd: AdItem) -> AnyPublisher<[AdItem], any Error> {
        favouritesService
            .updateFavouriteAdItems(favouriteAds: [favouriteAd])
            .flatMap {_ in
                self.favouritesService
                    .readFromFavouriteAdItems()
            }
            .eraseToAnyPublisher()
    }
}
