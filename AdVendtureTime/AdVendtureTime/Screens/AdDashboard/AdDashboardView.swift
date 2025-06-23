//
//  ContentView.swift
//  AdVendtureTime
//
//  Created by Karoline Skumsrud Andersen on 20/06/2025.
//

import SwiftUI

struct AdDashboardView: View {
    @ObservedObject var viewModel = AdDashboardViewModel()
    
    var body: some View {
        let columns = [GridItem(.flexible(), spacing: 16),
                       GridItem(.flexible(), spacing: 16)]
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(viewModel.ads, id: \.id) { ad in
                    VendAdCardView(imageURL: ad.fullImageURL,
                                   title: ad.title,
                                   location: ad.location,
                                   priceValue: ad.priceValue,
                                   isFavourite: ad.isFavourite,
                                   onToggleFavourites: {
                        ad.isFavourite = !ad.isFavourite
                        if ad.isFavourite {
                            viewModel.saveToFavourites(ad: ad)
                        } else {
                            viewModel.removeFromFavourites(ad: ad)
                        }
                    })
                }
            }.padding(16)
        }
    }
}

#Preview {
    AdDashboardView()
}
