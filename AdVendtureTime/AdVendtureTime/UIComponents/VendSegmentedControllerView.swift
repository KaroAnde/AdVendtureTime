//
//  VendSegmentedControllerView.swift
//  AdVendtureTime
//
//  Created by Karoline Skumsrud Andersen on 21/06/2025.
//

import SwiftUI

struct VendSegmentedControllerView: View {
    var body: some View {
        @State var homeIsSelected = true
        @State var favouritesIsSelected = false
        ZStack {
            Capsule()
                .rotationEffect(.degrees(180))
                .foregroundStyle(.vendRust)
                .frame(width: 320, height: 65)
            
            HStack() {
                Button() {
                    print("home")
                } label: {
                    Text("Home")
                        .foregroundStyle(homeIsSelected ? .vendRust : .vendLightPink)
                        
                }
                .frame(width: 150, height: 55)
                .background(Capsule().fill(homeIsSelected ? .vendLightPink : .vendRust))
                
                Button() {
                    print("favourites")
                } label: {
                 Text("Favourites")
                        .foregroundStyle(favouritesIsSelected ? .vendRust : .vendLightPink)
                }
                .frame(width: 150, height: 55)
                .background(Capsule().fill(favouritesIsSelected ? .vendLightPink : .vendRust))
            }
        }
        
    }
}

#Preview {
    VendSegmentedControllerView()
}
