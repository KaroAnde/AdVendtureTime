//
//  FavouritesViewModel.swift
//  AdVendtureTime
//
//  Created by Karoline Skumsrud Andersen on 23/06/2025.
//
import Foundation
import Combine
import SwiftUI


class FavouritesViewModel: ObservableObject {
    @Published var favouriteAds: [AdItem] = []
    var cancellables = Set<AnyCancellable>()
    var favouritesService: FavouritesPersistenceService
    var repository: VendAdRepository
    @Published var isLoading: Bool = false
    
    init(service: FavouritesPersistenceService = FavouritesPersistenceService.shared){
        self.favouritesService = service
        self.repository = VendAdRepository(favouritesService: service)
        fetchAdsFromFile()
    }
    
    deinit {
        cancellables.forEach { $0.cancel() }
    }
    
    func fetchAdsFromFile() {
        self.isLoading = true
        repository.fetchAdsFromFile()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(_) = completion {
                    Haptics.shared.notify(.error)
                }
                self.isLoading = false
            }, receiveValue: { [weak self] localAdData in
                self?.favouriteAds = localAdData
            })
            .store(in: &cancellables)
    }
    
    func updateFavourites(adItem: AdItem) {
        self.isLoading = true
        repository.updateAndReadFavouriteItems(favouriteAd: adItem)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(_) = completion {
                    Haptics.shared.notify(.error)
                }
                self.isLoading = false
            }, receiveValue: { items  in
                self.favouriteAds = items
            })
            .store(in: &cancellables)
    }
}
