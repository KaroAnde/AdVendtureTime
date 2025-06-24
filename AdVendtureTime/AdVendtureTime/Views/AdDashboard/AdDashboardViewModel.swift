//
//  AdDashboardViewModel.swift
//  AdVendtureTime
//
//  Created by Karoline Skumsrud Andersen on 20/06/2025.
//

import SwiftUI
import Combine

class AdDashboardViewModel: ObservableObject {
    @Published var ads: [AdItem] = []
    var cancellables = Set<AnyCancellable>()
    var apiService: APIService
    var favouritesService: FavouritesPersistenceService
    var repository: VendAdRepository
    @Published var isLoading: Bool = false
    
    init(apiService: APIService = APIService.shared, favouritesService: FavouritesPersistenceService = FavouritesPersistenceService.shared) {
        self.apiService = apiService
        self.favouritesService = favouritesService
        self.repository = VendAdRepository(apiService: apiService, favouritesService: favouritesService)
        fetchAds()
    }
    
    deinit {
        cancellables.forEach { $0.cancel() }
    }
    
    func fetchAds() {
        self.isLoading = true
        repository.getAds()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(_) = completion {
                    Haptics.shared.notify(.error)
                }
                self.isLoading = false
            }, receiveValue: { [weak self] adData in
                self?.ads = adData
            })
            .store(in: &cancellables)
    }
    
    func updateFavourites(ad: AdItem) {
        self.isLoading = true
        favouritesService.updateFavouriteAdItems(favouriteAds: [ad])
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    self.isLoading = false
                }
                self.isLoading = false
            }, receiveValue: {_ in})
            .store(in: &cancellables)
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
                self?.ads = localAdData
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
                self.ads = items
            })
            .store(in: &cancellables)
    }
}
