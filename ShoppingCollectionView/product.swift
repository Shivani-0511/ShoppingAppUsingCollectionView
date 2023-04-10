//
//  product.swift
//  ShoppingCollectionView
//
//  Created by Akshay Yendhe on 13/02/23.
//

import Foundation
struct ProductsModel : Codable {
    let products : [product]
    let total : Int
    let skip : Int
    let limit : Int
}

struct product : Codable {
    let id : Int
    let title : String
    let description : String
    let price : Int
    let discountPercentage : Double
    let rating : Double
    let stock : Int
    let brand : String
    let category : String
    let thumbnail : String
    var images = [String]()
}
