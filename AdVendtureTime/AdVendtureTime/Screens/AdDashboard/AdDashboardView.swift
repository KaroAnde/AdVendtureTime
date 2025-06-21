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
        let columns = [GridItem(.flexible()), GridItem(.flexible())]
        ScrollView {
            LazyVGrid(columns: columns, spacing: 8) {
                ForEach(viewModel.ads, id: \.id) { ad in
                    VendAdCardView(imageURL: ad.fullImageURL,
                                   title: ad.title,
                                   location: ad.location,
                                   priceValue: ad.price?.value)
                    .padding(.horizontal, 8)
                }
            }
        }
    }
}

#Preview {
    AdDashboardView()
}
