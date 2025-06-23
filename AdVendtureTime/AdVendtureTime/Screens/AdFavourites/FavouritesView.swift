//
//  FavouritesView.swift
//  AdVendtureTime
//
//  Created by Karoline Skumsrud Andersen on 22/06/2025.
//

import SwiftUI
import SwiftData

struct FavouritesView: View {
    @ObservedObject var viewModel: FavouritesViewModel = FavouritesViewModel()
    var body: some View {
        if viewModel.favouriteAds.isEmpty {
            Text ("No favourites yet")
        }
        ScrollView {
            LazyVStack {
                ForEach($viewModel.favouriteAds, id: \.id) { favouriteAd in
                    VendAdCardView(imageURL: favouriteAd.fullImageURL.wrappedValue,
                                   title: favouriteAd.title.wrappedValue,
                                   location: favouriteAd.location.wrappedValue,
                                   priceValue: favouriteAd.priceValue.wrappedValue,
                                   isFavourite: favouriteAd.isFavourite)
                }
            }.padding(16)
        }
    }
}

#Preview {
    FavouritesView()
}
