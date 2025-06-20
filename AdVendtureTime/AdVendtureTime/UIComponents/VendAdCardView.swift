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
    let priceTotal: String?
    
    var body: some View {
        Text("Hello, World!")
    }
}

#Preview {
    VendAdCardView(
        imageURL: URL(string: "https://images.finncdn.no/dynamic/480x360c/2023/8/vertical-2/31/6/317/711/106_420660047.jpg"),
        title: "Volvo EX40",
        location: "Notodden",
        priceTotal: "1234")
}
