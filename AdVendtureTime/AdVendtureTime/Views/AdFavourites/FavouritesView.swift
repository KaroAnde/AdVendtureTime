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
            emptyView
        }
        ScrollView {
            LazyVStack {
                ForEach(viewModel.favouriteAds.indices.reversed(), id: \.self) { i in
                    let favouriteAd = viewModel.favouriteAds[i]
                    VendAdCardView(imageURL: favouriteAd.localImageFileName,
                                   title: favouriteAd.title,
                                   location: favouriteAd.location,
                                   priceValue: favouriteAd.priceValue,
                                   isFavourite: $viewModel.favouriteAds[i].isFavourite, isLoading: $viewModel.isLoading)
                    .onChange(of: viewModel.favouriteAds[i].isFavourite) { _, newValue in
                        viewModel.updateFavourites(adItem: favouriteAd)
                    }
                }
            }.padding(16)
        }
    }
    
    @ViewBuilder
    var emptyView: some View {
        VStack {
            Spacer()
            Image(systemName:"star.slash")
                .resizable()
                .frame(width: 50, height: 50)
                .foregroundStyle(.vendRust)
            Text("No favourites yet")
                .titleStyle()
        }
        .padding()
    }
}

#Preview {
    FavouritesView()
}
