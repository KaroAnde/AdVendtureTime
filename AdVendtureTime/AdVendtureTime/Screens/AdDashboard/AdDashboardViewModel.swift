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
    var service: APIService
    var repository: AdDashboardRepository
    
    init(service: APIService = APIService.shared) {
        self.service = service
        self.repository = AdDashboardRepository(apiService: service)
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
    
    func fetchAdsFromFile() {
        FileManager.default.readFavouriteAds()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("+ handle error", error)
                }
            }, receiveValue: { [weak self] localAdData in
                
            })
            .store(in: &cancellables)
    }
    
    func saveToFavourites(ad: LocalAdItem) {
        FileManager.default.testWriteToLocalAdItem(newFavouriteAds: [ad])
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
    
    func removeFromFavourites(ad: LocalAdItem) {
        FileManager.default.removeFavouriteAdItem(adToRemove: ad)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("+ handle error", error)
                }
            }, receiveValue: { [weak self] saved in
                print("+ localAdData removed", saved)
            })
            .store(in: &cancellables)
    }
}
