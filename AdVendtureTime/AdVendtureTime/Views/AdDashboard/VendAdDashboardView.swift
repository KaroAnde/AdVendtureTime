//
//  ContentView.swift
//  AdVendtureTime
//
//  Created by Karoline Skumsrud Andersen on 20/06/2025.
//

import SwiftUI

struct VendAdDashboardView: View {
    @StateObject var viewModel: AdDashboardViewModel = AdDashboardViewModel()
    @Binding var shouldShowFavourites: Bool
    
    var body: some View {
        ScrollView {
            if shouldShowFavourites {
                favouriteView
            } else {
                allAdsView
            }
        }
    }
    
    @ViewBuilder var allAdsView: some View {
        let columns = [GridItem(.flexible(), spacing: spacing),
                       GridItem(.flexible(), spacing: spacing)]
        
        LazyVGrid(columns: columns, spacing: spacing) {
            ForEach(viewModel.ads.indices, id: \.self) { index in
                let adBinding = $viewModel.ads[index]
                
                VendAdCardView(
                    imageURL: adBinding.fullImageURL.wrappedValue,
                    title: adBinding.title.wrappedValue,
                    location: adBinding.location.wrappedValue,
                    priceValue: adBinding.priceValue.wrappedValue,
                    isFavourite: adBinding.isFavourite,
                    isLoading: $viewModel.isLoading
                )
                .onChange(of: adBinding.isFavourite.wrappedValue) { old, new in
                    viewModel.updateFavourites(ad: adBinding.wrappedValue)
                }
            }
        }
        .padding(padding)
    }
    
    @ViewBuilder var favouriteView: some View {
        LazyVStack {
            let favIndices = viewModel.ads
                .indices
                .filter { viewModel.ads[$0].isFavourite }
            
            LazyVStack {
                ForEach(favIndices, id: \.self) { index in
                    let adBinding = $viewModel.ads[index]
                    
                    VendAdCardView(
                        imageURL: adBinding.fullImageURL.wrappedValue,
                        title: adBinding.title.wrappedValue,
                        location: adBinding.location.wrappedValue,
                        priceValue: adBinding.priceValue.wrappedValue,
                        isFavourite: adBinding.isFavourite,
                        isLoading: $viewModel.isLoading
                    ).onChange(of: adBinding.isFavourite.wrappedValue) { old, new in
                        viewModel.updateFavourites(ad: adBinding.wrappedValue)
                    }
                }
            }
            
        }.padding(padding)
    }
}

#Preview {
    VendAdDashboardView(shouldShowFavourites: .constant(true))
}
