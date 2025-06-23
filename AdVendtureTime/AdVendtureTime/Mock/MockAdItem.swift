//
//  MockAdItem.swift
//  AdVendtureTime
//
//  Created by Karoline Skumsrud Andersen on 23/06/2025.
//
import Foundation

extension AdItem {
    static func mock(
        title: String? = "Sample Ad",
        id: String = UUID().uuidString,
        url: String? = "https://example.com",
        adType: String = "DefaultType",
        location: String? = "Oslo",
        type: String? = "General",
        priceValue: Int? = 99,
        score: Double? = 4.5,
        version: String? = "1.0",
        shippingOption: String? = "Free",
        isFavourite: Bool = false,
        fullImageURL: URL? = URL(string: "https://example.com/image.png"),
        localImageFileName: String? = "https://example.com/image.png"
    ) -> AdItem {
        AdItem(
            title: title,
            id: id,
            url: url,
            adType: adType,
            location: location,
            type: type,
            priceValue: priceValue,
            score: score,
            version: version,
            shippingOption: shippingOption,
            isFavourite: isFavourite,
            fullImageURL: fullImageURL,
            localImageFileName: localImageFileName
        )
    }

    /// A handful of sample items you can use directly.
    static var mockList: [AdItem] {
        [
            .mock(title: "Red Bicycle", id: "1", priceValue: 150, isFavourite: true),
            .mock(title: "Vintage Lamp", id: "2", priceValue: 75),
            .mock(title: "Gaming Console", id: "3", priceValue: 299, score: 4.8, shippingOption: "Express"),
        ]
    }
}
