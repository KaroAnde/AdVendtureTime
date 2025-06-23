//
//  AdDashboardViewModel.swift
//  AdVendtureTime
//
//  Created by Karoline Skumsrud Andersen on 20/06/2025.
//

import SwiftUI
import Combine

class AdDashboardViewModel: ObservableObject {
    @Published var ads: [LocalAdItem] = []
    var cancellables = Set<AnyCancellable>()
    var apiService: APIService
    var favouritesService: FavouritesPersistenceService
    var repository: AdDashboardRepository
    
    init(apiService: APIService = APIService.shared, favouritesService: FavouritesPersistenceService = FavouritesPersistenceService.shared) {
        self.apiService = apiService
        self.favouritesService = favouritesService
        self.repository = AdDashboardRepository(apiService: apiService, favouritesService: favouritesService)
        fetchAds()
    }
    
    deinit {
        cancellables.forEach { $0.cancel() }
    }
    
    func fetchAds() {
        repository.getAds()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("+ handle error", error)
                }
            }, receiveValue: { [weak self] adData in
                self?.ads = adData
            })
            .store(in: &cancellables)
    }
    
    func updateFavourites(ad: LocalAdItem) {
        favouritesService.updateFavouriteAdItems(favouriteAds: [ad])
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("+ handle error", error)
                }
            }, receiveValue: { [weak self] saved in
                print("+ localAdData saved", saved)
            })
            .store(in: &cancellables)
    }
}
