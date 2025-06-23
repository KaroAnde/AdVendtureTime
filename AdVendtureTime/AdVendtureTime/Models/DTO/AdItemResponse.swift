//
//  AdItem.swift
//  AdVendtureTime
//
//  Created by Karoline Skumsrud Andersen on 20/06/2025.
//
import Foundation

struct AdItemResponse: Codable, Identifiable {
    var title: String?
    var id: String
    var url: String?
    var adType: String
    var location: String?
    var type: String?
    var price: AdPrice?
    var categories: AdCategories?
    var image: AdImage?
    var score: Double?
    var version: String?
    var favourite: AdFavourite?
    var shippingOption: AdShippingOption?
    
    var fullImageURL: URL? {
        guard let imageUrl = image?.url else { return nil }
        return URL(string: APIConfig.imagesBaseURL + imageUrl)
    }
    
    enum CodingKeys: String, CodingKey {
        case id, url, location, type, price, categories, image, score, version, favourite
        case adType = "ad-type"
        case title = "description"
    }
}



