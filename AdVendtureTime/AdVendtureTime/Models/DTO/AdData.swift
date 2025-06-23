//
//  AdData.swift
//  AdVendtureTime
//
//  Created by Karoline Skumsrud Andersen on 20/06/2025.
//

struct AdData: Decodable {
    var isPersonal: Bool?
    var hasConsent: Bool?
    var items: [AdItemResponse]
}
