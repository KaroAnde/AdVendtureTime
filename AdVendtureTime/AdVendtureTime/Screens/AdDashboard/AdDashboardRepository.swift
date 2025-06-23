//
//  AdDashboardRepository.swift
//  AdVendtureTime
//
//  Created by Karoline Skumsrud Andersen on 22/06/2025.
//

import Combine
import Foundation

protocol AdDashboardRepositoryProtocol {
    func getAds() -> AnyPublisher<[LocalAdItem], Error>
}

class AdDashboardRepository: AdDashboardRepositoryProtocol {
    let apiService: APIService
    let favouritesService: FavouritesPersistenceService
    
    init(apiService: APIService = APIService.shared, favouritesService: FavouritesPersistenceService) {
        self.apiService = apiService
        self.favouritesService = favouritesService
    }
    
    func getAds() -> AnyPublisher<[LocalAdItem], Error> {
       let apiAds = apiService.fetchAds().map { ads in
            ads.items.map { adItem in
                            LocalAdItem(item: adItem,
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
    
    func updateFavourites(newFavouriteAd: LocalAdItem) -> AnyPublisher<URL, Error>{
        favouritesService.updateFavouriteAdItems(favouriteAds: [newFavouriteAd]).eraseToAnyPublisher()
    }
    
    func fetchAdsFromFile() -> AnyPublisher<[LocalAdItem], Error> {
        favouritesService
            .readFromFavouriteAdItems().eraseToAnyPublisher()
    }
}
