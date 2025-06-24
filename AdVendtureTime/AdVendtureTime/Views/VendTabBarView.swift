//
//  VendTabBarView.swift
//  AdVendtureTime
//
//  Created by Karoline Skumsrud Andersen on 22/06/2025.
//

import SwiftUI

struct VendTabBarView: View {
    var body: some View {
        VendCustomTabbar()
    }
}

#Preview {
    VendTabBarView()
}

struct VendCustomTabbar: View {
    @State var shouldShowFavourites = false
    var body: some View {
        VStack(spacing: 0){
            AdDashboardView(shouldShowFavourites: $shouldShowFavourites)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .overlay(alignment: .bottom) {
            tabBar
        }
    }
    
    @ViewBuilder
    var tabBar: some View {
        ZStack {
            Capsule()
                .rotationEffect(.degrees(180))
                .frame(width: capsuleWidth, height: capsuleHeight)
                .foregroundStyle(.vendRust)
                .opacity(0.9)
            HStack {
                VStack {
                    Image(systemName: "house")
                        .frame(width: iconSize, height: iconSize)
                    Text("Home")
                }
                .foregroundStyle(!shouldShowFavourites ? .vendRust : .vendDarkerPink)
                .frame(width: buttonWidth, height: buttonHeight)
                .background(Capsule().fill(!shouldShowFavourites ? .vendDarkerPink : .vendRust))
                .padding()
                .onTapGesture {
                    shouldShowFavourites = false
                }
                
                VStack {
                    Image(systemName: "star")
                        .frame(width: iconSize, height: iconSize)
                    Text("Favourites")
                }
                .foregroundStyle(shouldShowFavourites ? .vendRust : .vendDarkerPink)
                .frame(width: buttonWidth, height: buttonHeight)
                .background(Capsule().fill(shouldShowFavourites ? .vendDarkerPink : .vendRust))
                .padding()
                .onTapGesture {
                    shouldShowFavourites = true
                }
            }
            .foregroundStyle(.vendLightPink)
        }
    }
}
