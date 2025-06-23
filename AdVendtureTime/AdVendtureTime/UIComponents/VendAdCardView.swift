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
    @Binding var isFavourite: Bool
    @Binding var isLoading: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            asyncImageView
            VStack(alignment: .leading, spacing: 16) {
                Text(location ?? "")
                    .descriptionStyle()
                    .accessibilityModifiers(label: location ?? "Location is missing")
                
                Text(title ?? "")
                    .titleStyle()
                    .lineLimit(2)
                    .accessibilityModifiers(label: title ?? "Title is missing")
            }
            .padding(8)
        }
        .background(.vendDarkerPink)
        .clipShape(.rect(cornerRadius: 8))
    }
    
    @ViewBuilder
    var asyncImageView: some View {
        AsyncImage(url: imageURL) { phase in
            switch phase {
            case .empty:
                emptyImageView
            case .success(let image):
                image
                    .resizable()
                    .scaledToFit()
                    .transition(.opacity)
                    .animation(.easeIn(duration: 0.3), value: phase.image)
            case .failure(_):
                emptyImageView
            @unknown default:
                emptyImageView
            }
        }
        .frame(maxWidth: .infinity)
        .clipped()
        .clipShape(.rect(cornerRadius: 8))
        .overlay(alignment: .topTrailing) {
            favouriteButton
        }
        .overlay(alignment: .bottomLeading) {
            priceValueText
        }
        .accessibilityModifiers(label: title ?? "Description is missing",
                                traits: .isImage)
    }
    
    @ViewBuilder
    var favouriteButton: some View {
        Image(systemName: isFavourite ? "heart.fill" : "heart" )
            .resizable()
            .scaledToFit()
            .padding(8)
            .frame(width: 44, height: 44)
            .foregroundStyle(.vendRust)
            .background(.vendLightPink)
            .clipShape(.rect(bottomLeadingRadius: 8))
            .onTapGesture {
                isFavourite.toggle()
            }
    }
    
    @ViewBuilder
    var priceValueText: some View {
        if let priceValue = priceValue {
            Text((priceValue.separatorFormatted()) + " Kr")
                .padding(.horizontal, 16)
                .foregroundStyle(.vendDarkerPink)
                .background(.vendRust)
                .clipShape(.rect(topTrailingRadius: 8))
                .lineLimit(2)
                .accessibilityModifiers(label: String(priceValue),
                                        hint: "Price of item")
        }
    }
    
    @ViewBuilder
    var emptyImageView: some View {
        ZStack {
            if isLoading {
                ProgressView()
                .scaleEffect(4.0)
            }
            Image(systemName: "photo.badge.exclamationmark")
                .resizable()
                .scaledToFit()
                .padding()
                .foregroundStyle(.vendRust)
                .opacity(0.5)
        }
    }
}

struct VendAdCardPreviewHelper: View {
    @ObservedObject var viewModel: AdDashboardViewModel
    @State var isFavourite: Bool = false
    init(mockType: MockAdDataType) {
        let mockData = MockAdData(mockType: mockType)
        self.viewModel = AdDashboardViewModel(apiService: mockData.mockService())
    }
    
    var body: some View {
        VendAdCardView(
            imageURL: viewModel.ads.first?.fullImageURL,
            title: viewModel.ads.first?.title,
            location: viewModel.ads.first?.location,
            priceValue: viewModel.ads.first?.priceValue,
            isFavourite: $isFavourite, isLoading: $viewModel.isLoading)
    }
}


#Preview {
    VendAdCardPreviewHelper(mockType: .nilValuesMock)
}
