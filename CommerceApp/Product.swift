//
//  Product.swift
//  CommerceApp
//
//  Created by Pradheep Narendran P on 03/08/23.
//

import Foundation

class ProductData: Codable {
    let productID: Int?
    let productName: String?
    let productDescription: String?
    let productPrice: Double?
    let productImageURL: String?
    let productCategory: String?
    let rating: Rating?
    
    enum CodingKeys: String, CodingKey {
        case productID = "id"
        case productName = "title"
        case productDescription = "description"
        case productPrice = "price"
        case productImageURL = "image"
        case productCategory = "category"
        case rating
    }
    
}


class Rating: Codable {
    let rate: Double?
    
    enum CodingKeys: String, CodingKey {
        case rate
    }
    
}
