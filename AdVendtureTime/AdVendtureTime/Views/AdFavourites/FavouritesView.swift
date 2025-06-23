//
//  FavouritesView.swift
//  AdVendtureTime
//
//  Created by Karoline Skumsrud Andersen on 22/06/2025.
//

import SwiftUI

struct FavouritesView: View {
    @StateObject var viewModel: FavouritesViewModel
    var body: some View {
        if viewModel.favouriteAds.isEmpty {
            emptyView
        }
        ScrollView {
            LazyVStack {
                ForEach(viewModel.favouriteAds.indices.reversed(), id: \.self) { i in
                    let favouriteAd = viewModel.favouriteAds[i]
                    VendAdCardView(imageURL: favouriteAd.fullImageURL,
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
        let imageSize: CGFloat = 50
        VStack {
            Spacer()
            Image(systemName:"star.slash")
                .resizable()
                .frame(width: imageSize, height: imageSize)
                .foregroundStyle(.vendRust)
            Text("No favourites yet")
                .titleStyle()
        }
        .padding()
    }
}

#Preview {
    FavouritesView(viewModel: FavouritesViewModel())
}
