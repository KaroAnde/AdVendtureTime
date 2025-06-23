//
//  ContentView.swift
//  AdVendtureTime
//
//  Created by Karoline Skumsrud Andersen on 20/06/2025.
//

import SwiftUI

struct AdDashboardView: View {
    @StateObject var viewModel: AdDashboardViewModel
 
    
    var body: some View {
        let columns = [GridItem(.flexible(), spacing: spacing),
                       GridItem(.flexible(), spacing: spacing)]
        ScrollView {
            LazyVGrid(columns: columns, spacing: spacing) {
                ForEach(viewModel.ads.indices, id: \.self) { i in
                    let ad = viewModel.ads[i]
                    VendAdCardView(imageURL: ad.fullImageURL,
                                   title: ad.title,
                                   location: ad.location,
                                   priceValue: ad.priceValue,
                                   isFavourite: $viewModel.ads[i].isFavourite,
                                   isLoading: $viewModel.isLoading)
                    .onChange(of: viewModel.ads[i].isFavourite) { _, newValue in
                        viewModel.updateFavourites(ad: ad)
                    }
                }
            }.padding(padding)
        }
    }
}

#Preview {
    AdDashboardView(viewModel: AdDashboardViewModel())
}
