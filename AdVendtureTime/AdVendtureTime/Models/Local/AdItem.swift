//
//  AdItem.swift
//  AdVendtureTime
//
//  Created by Karoline Skumsrud Andersen on 22/06/2025.
//

import Foundation

class AdItem: Codable {
    var title: String?
    var id: String
    var url: String?
    var adType: String
    var location: String?
    var type: String?
    var priceValue: Int?
    var score: Double?
    var version: String?
    var shippingOption: String?
    var isFavourite: Bool
    var fullImageURL: URL?
    
    init(title: String?,
         id: String,
         url: String?,
         adType: String,
         location: String?,
         type: String?,
         priceValue: Int?,
         score: Double?,
         version: String?,
         shippingOption: String?,
         isFavourite: Bool = false,
         fullImageURL: URL?) {
        self.title = title
        self.id = id
        self.url = url
        self.adType = adType
        self.location = location
        self.type = type
        self.priceValue = priceValue
        self.score = score
        self.version = version
        self.shippingOption = shippingOption
        self.isFavourite = isFavourite
        self.fullImageURL = fullImageURL
    }
}

extension AdItem {
    convenience init(item: AdItemResponse, priceValue: Int?, shippingOption: String?, isFavourite: Bool = false, fullImageURL: URL?) {
        self.init(
            title: item.title,
            id: item.id,
            url: item.url,
            adType: item.adType,
            location: item.location,
            type: item.type,
            priceValue: priceValue,
            score: item.score,
            version: item.version,
            shippingOption: shippingOption,
            isFavourite: isFavourite,
            fullImageURL: fullImageURL
        )
    }
}

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
        fullImageURL: URL? = URL(string: "https://example.com/image.png")
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
            fullImageURL: fullImageURL
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
