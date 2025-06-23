//
//  VendTabBarView.swift
//  AdVendtureTime
//
//  Created by Karoline Skumsrud Andersen on 22/06/2025.
//

import SwiftUI
import SwiftData

struct VendTabBarView: View {
    var body: some View {
        VendCustomTabbar()
    }
}

#Preview {
    VendTabBarView()
}

struct VendCustomTabbar: View {
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
                .frame(width: 350, height: 60)
                .foregroundStyle(.vendRust)
                .opacity(0.9)
            HStack {
                    Button(action: { selectedTab = 0}) {
                        VStack {
                            Image(systemName: "house")
                                .frame(width: 20, height: 20)
                            Text("Home")
                        }
                        .foregroundStyle(selectedTab == 0 ? .vendRust : .vendDarkerPink)
                    }
                    .frame(width: 150, height: 55)
                    .background(Capsule().fill(selectedTab == 0 ? .vendDarkerPink : .vendRust))
                    .padding()
                
                
                    Button(action: { selectedTab = 1}) {
                        VStack {
                            Image(systemName: "star")
                                .frame(width: 20, height: 20)
                            Text("Favourites")
                        }.foregroundStyle(selectedTab == 1 ? .vendRust : .vendDarkerPink)
                    }
                    .frame(width: 150, height: 55)
                    .background(Capsule().fill(selectedTab == 1 ? .vendDarkerPink : .vendRust))
                    .padding()
            }
            .foregroundStyle(.vendLightPink)
            
        }
    }
    
    @ViewBuilder
    var tabContent: some View {
        switch selectedTab {
        case 0:
            AdDashboardView()
        case 1:
            FavouritesView()
        default:
            AdDashboardView()
        }
    }
}
