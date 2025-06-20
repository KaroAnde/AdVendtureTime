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
    
    deinit {
        cancellables.forEach { $0.cancel() }
    }
    
    func fetchAds() {
        APIService.shared.fetchAds()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("+ finished")
                case .failure(let error):
                    print("+ error: ", error)
                }
            }, receiveValue: { [weak self] adData in
                self?.ads = adData.items
                print("+ ads from request: ", adData)
                print("+ ads in viewmodel: ", self?.ads)
            })
            .store(in: &cancellables)
        
    }
}
