//
//  AdDashboardRepository.swift
//  AdVendtureTime
//
//  Created by Karoline Skumsrud Andersen on 22/06/2025.
//

import Combine
import Foundation

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
    
    func getAds() -> AnyPublisher<[AdItem], Error> {
       let apiAds = apiService.fetchAds().map { ads in
            ads.items.map { adItem in
                            AdItem(item: adItem,
                                   priceValue: adItem.price?.value,
                                   shippingOption: adItem.shippingOption?.label,
                                   isFavourite: false,
                                   fullImageURL: adItem.fullImageURL)
            }
        }
        
        let favourites = self.fetchAdsFromFile()
        
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
        favouritesService.updateFavouriteAdItems(favouriteAds: [newFavouriteAd])
            .eraseToAnyPublisher()
    }
    
    func fetchAdsFromFile() -> AnyPublisher<[AdItem], Error> {
        favouritesService
            .readFromFavouriteAdItems()
            .eraseToAnyPublisher()
    }
    
    func updateAndReadFavouriteItems(favouriteAd: AdItem) -> AnyPublisher<[AdItem], any Error> {
        favouritesService
            .updateFavouriteAdItems(favouriteAds: [favouriteAd])
            .flatMap {_ in
                self.favouritesService.readFromFavouriteAdItems()
            }
            .eraseToAnyPublisher()
    }
}
