//
//  View + style.swift
//  AdVendtureTime
//
//  Created by Karoline Skumsrud Andersen on 20/06/2025.
//

import SwiftUI

extension View {
    func titleStyle() -> some View {
        self
            .foregroundStyle(.vendRust)
            .multilineTextAlignment(.leading)
            .font(.title3)
    }
    
    func descriptionStyle() -> some View {
        self
            .foregroundStyle(.vendRust)
            .multilineTextAlignment(.leading)
            .font(.body)
    }
}
