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
