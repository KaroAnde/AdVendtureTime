//
//  Haptics.swift
//  AdVendtureTime
//
//  Created by Karoline Skumsrud Andersen on 23/06/2025.
//
import UIKit

class Haptics {
    static let shared = Haptics()
    
    private init() { }

    func play(_ feedbackStyle: UIImpactFeedbackGenerator.FeedbackStyle) {
        UIImpactFeedbackGenerator(style: feedbackStyle).impactOccurred()
    }
    
    func notify(_ feedbackType: UINotificationFeedbackGenerator.FeedbackType) {
        UINotificationFeedbackGenerator().notificationOccurred(feedbackType)
    }
    
    func select() {
        UISelectionFeedbackGenerator().selectionChanged()
    }
}
