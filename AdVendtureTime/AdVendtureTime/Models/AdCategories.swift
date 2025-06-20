//
//  AdCategories.swift
//  AdVendtureTime
//
//  Created by Karoline Skumsrud Andersen on 20/06/2025.
//

struct AdCategories: Decodable {
    var mainCategory: String?
    var subCategory: String?
    var prodCategory: String?
    
    enum CodingKeys: String, CodingKey {
        case mainCategory = "main_category"
        case subCategory = "sub_category"
        case prodCategory = "prod_category"
    }
}
