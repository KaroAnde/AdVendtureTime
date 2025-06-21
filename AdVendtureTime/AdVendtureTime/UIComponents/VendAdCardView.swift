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
    let priceValue: Int?
    
    var body: some View {
        VStack(spacing: 8) {
            asyncImageView
            
            VStack(alignment: .leading) {
                Text(title ?? "")
                    .titleStyle()
                    .padding()
                    .lineLimit(1)
                    .accessibilityModifiers(label: title ?? "Title is missing")
                
                Text(location ?? "")
                    .bold()
                    .descriptionStyle()
                    .padding()
                    .accessibilityModifiers(label: location ?? "Location is missing")
            }
        }
        .clipShape(.rect(cornerRadius: 10))
        .background(.vendDarkerPink)
    }
    
    @ViewBuilder
    var asyncImageView: some View {
        ZStack(alignment: .bottomLeading) {
            AsyncImage(url: imageURL) { phase in
                switch phase {
                case .empty:
                    emptyImageView
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                case .failure(_):
                    emptyImageView
                @unknown default:
                    emptyImageView
                }
            }
            .accessibilityModifiers(label: title ?? "Description is missing")
            
            Text((priceValue?.separatorFormatted() ?? "") + " Kr")
                .padding(.horizontal, 16)
                .foregroundStyle(.vendLightPink)
                .background(.vendRust)
                .clipShape(.rect(topTrailingRadius: 8))
                .lineLimit(2)
                .accessibilityModifiers(label: String(priceValue ?? 0),
                                        hint: "Price of item")
        }
    }
    
    @ViewBuilder
    var emptyImageView: some View {
        Image("missingImage")
            .resizable()
            .aspectRatio(contentMode: .fit)
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
            priceValue: viewModel.ads.first?.price?.value)
    }
}

#Preview {
    VendAdCardPreviewHelper(mockType: .nilValuesMock)
}
