//
//  FavouritesView.swift
//  AdVendtureTime
//
//  Created by Karoline Skumsrud Andersen on 22/06/2025.
//

import SwiftUI

struct FavouritesView: View {
    @ObservedObject var viewModel: FavouritesViewModel = FavouritesViewModel()
    var body: some View {
        if viewModel.favouriteAds.isEmpty {
            Text ("No favourites yet")
        }
        ScrollView {
            LazyVStack {
                ForEach(viewModel.favouriteAds.indices, id: \.self) { i in
                    let favouriteAd = viewModel.favouriteAds[i]
                    VendAdCardView(imageURL: favouriteAd.fullImageURL,
                                   title: favouriteAd.title,
                                   location: favouriteAd.location,
                                   priceValue: favouriteAd.priceValue,
                                   isFavourite: $viewModel.favouriteAds[i].isFavourite)
                    .onChange(of: viewModel.favouriteAds[i].isFavourite) { newValue in
                        viewModel.updateFavourites(adItem: favouriteAd)
                    }
                }
            }.padding(16)
        }
    }
}

#Preview {
    FavouritesView()
}
