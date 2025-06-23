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
    let adDashboardViewModel = AdDashboardViewModel()
    let favouritesViewModel = FavouritesViewModel()
    @State private var selectedTab = 0
    var body: some View {
        VStack(spacing: 0){
            tabContent
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
                .foregroundStyle(selectedTab == 0 ? .vendRust : .vendDarkerPink)
                .frame(width: buttonWidth, height: buttonHeight)
                .background(Capsule().fill(selectedTab == 0 ? .vendDarkerPink : .vendRust))
                .padding()
                .onTapGesture {
                    selectedTab = 0
                }
                
                VStack {
                    Image(systemName: "star")
                        .frame(width: iconSize, height: iconSize)
                    Text("Favourites")
                }
                .foregroundStyle(selectedTab == 1 ? .vendRust : .vendDarkerPink)
                .frame(width: buttonWidth, height: buttonHeight)
                .background(Capsule().fill(selectedTab == 1 ? .vendDarkerPink : .vendRust))
                .padding()
                .onTapGesture {
                    selectedTab = 1
                }
            }
            .foregroundStyle(.vendLightPink)
        }
    }
    
    @ViewBuilder
    var tabContent: some View {
        switch selectedTab {
        case 0:
            AdDashboardView(viewModel: adDashboardViewModel)
        case 1:
            FavouritesView(viewModel: favouritesViewModel)
        default:
            AdDashboardView(viewModel: adDashboardViewModel)
        }
    }
}
