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
    @Published var favouriteAds: [LocalAdItem] = []
    var cancellables = Set<AnyCancellable>()
    var favouritesService: FavouritesPersistenceService
    var repository: AdDashboardRepository
    
    init(service: FavouritesPersistenceService = FavouritesPersistenceService.shared){
        self.favouritesService = service
        self.repository = AdDashboardRepository(favouritesService: service)
        fetchAdsFromFile()
    }
    
    deinit {
        cancellables.forEach { $0.cancel() }
    }
    
    func fetchAdsFromFile() {
        repository.fetchAdsFromFile()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("+ handle error", error)
                }
            }, receiveValue: { [weak self] localAdData in
                self?.favouriteAds = localAdData
            })
            .store(in: &cancellables)
    }
    
}
