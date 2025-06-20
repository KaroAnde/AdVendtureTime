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
        VStack {
            Button("Fetch ads") {
                viewModel.fetchAds()
            }
        }
        .padding()
    }
}

#Preview {
    AdDashboardView()
}
