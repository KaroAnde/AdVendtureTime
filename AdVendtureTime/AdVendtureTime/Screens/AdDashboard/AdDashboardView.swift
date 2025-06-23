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
                ForEach(viewModel.ads.indices, id: \.self) { i in
                    let ad = viewModel.ads[i]
                    VendAdCardView(imageURL: ad.fullImageURL,
                                   title: ad.title,
                                   location: ad.location,
                                   priceValue: ad.priceValue,
                                   isFavourite: $viewModel.ads[i].isFavourite)
                    .onChange(of: viewModel.ads[i].isFavourite) { newValue in
                        viewModel.updateFavourites(ad: ad)
                    }
                }
            }.padding(16)
        }
    }
}

#Preview {
    AdDashboardView()
}
