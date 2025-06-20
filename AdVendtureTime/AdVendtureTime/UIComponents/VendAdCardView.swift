//
//  VendAdCardView.swift
//  AdVendtureTime
//
//  Created by Karoline Skumsrud Andersen on 20/06/2025.
//

import SwiftUI

struct VendAdCardView: View {
    let imageURL: URL?
    var title: String?
    var location: String?
    let priceTotal: Int?
    
    var body: some View {
        VStack(spacing: 8) {
            asyncImageView
            
            VStack(alignment: .leading) {
                Text(title ?? "")
                    .titleStyle()
                    .padding()
                
                Text(location ?? "")
                    .bold()
                    .descriptionStyle()
                    .padding()
            }
        }
        .clipShape(.rect(cornerRadius: 10))
        .background(.vendDarkerPink)    }
    
    @ViewBuilder
    var asyncImageView: some View {
        ZStack(alignment: .bottomLeading) {
            AsyncImage(url: imageURL) { phase in
                switch phase {
                case .empty:
                    Text("Return emptyview")
                case .success(let image):
                    image.resizable().aspectRatio(contentMode: .fit)
                case .failure(_):
                    Text("Return failure view")
                @unknown default:
                    Text("Return unknown default")
                }
            }
            Text((priceTotal?.separatorFormatted() ?? "maah") + " Kr")
                .padding(.horizontal, 16)
                .foregroundStyle(.vendLightPink)
                .background(.vendRust)
                .clipShape(.rect(topTrailingRadius: 8))
                .lineLimit(2)

        }
    }
}

struct VendAdCardPreviewHelper: View {
    @ObservedObject var viewModel: AdDashboardViewModel
    
    init(mockType: MockAdDataType) {
        let mockData = MockAdData(mockType: mockType)
        self.viewModel = AdDashboardViewModel(service: mockData.mockService())
    }
    
    var body: some View {
         VendAdCardView(
            imageURL: viewModel.ads.first?.fullImageURL,
            title: viewModel.ads.first?.title,
            location: viewModel.ads.first?.location,
            priceTotal: viewModel.ads.first?.price?.total)
    }
}

#Preview {
    VendAdCardPreviewHelper(mockType: .nonNilValuesMock)
}
