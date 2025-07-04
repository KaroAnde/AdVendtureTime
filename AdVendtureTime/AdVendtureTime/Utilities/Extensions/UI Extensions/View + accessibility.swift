//
//  View + accessibility.swift
//  AdVendtureTime
//
//  Created by Karoline Skumsrud Andersen on 20/06/2025.
//

import SwiftUI

extension View {
    /// Applies accessibility modifier with label, hint and traits.
    /// - Parameters:
    ///  - label: Used for voiceover. Will be spoken.
    ///  - hint: A hint that is also used for voiceover. Should describe what the element does if necessary
    ///  - traits: Defines the elements role (e.g ".isButton", ".isHeader")
    func accessibilityModifiers(label: String, hint: String? = nil, traits: AccessibilityTraits? = nil) -> some View {
        var accessibilityConfiguration = self
            .accessibilityLabel(label)
        
        if let traits = traits {
            accessibilityConfiguration = accessibilityConfiguration.accessibilityAddTraits(traits)
        }
        
        if let hint = hint {
            accessibilityConfiguration = accessibilityConfiguration.accessibilityHint(hint)
        }
        
        return accessibilityConfiguration
    }
}
