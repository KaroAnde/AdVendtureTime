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
    var service: APIService
    
    init(service: APIService = APIService.shared) {
        self.service = service
        fetchAds()
    }
    
    deinit {
        cancellables.forEach { $0.cancel() }
    }
    
    func fetchAds() {
        service.fetchAds()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("+ handle error", error)
                }
            }, receiveValue: { [weak self] adData in
                self?.ads = adData.items
            })
            .store(in: &cancellables)
        
    }
}
