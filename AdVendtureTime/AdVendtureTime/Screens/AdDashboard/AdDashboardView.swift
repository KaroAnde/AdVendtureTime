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
        let columns = [GridItem(.flexible(), spacing: 8), GridItem(.flexible(), spacing: 8)]
        ScrollView {
            LazyVGrid(columns: columns) {
                ForEach(viewModel.ads, id: \.id) { ad in
                    VendAdCardView(imageURL: ad.fullImageURL,
                                   title: ad.title,
                                   location: ad.location,
                                   priceValue: ad.price?.value)
                    .padding(.horizontal, 16)
                }
            }
        }
    }
}

#Preview {
    AdDashboardView()
}
