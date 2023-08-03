//
//  ProductDetailsViewModel.swift
//  CommerceApp
//
//  Created by Pradheep Narendran P on 04/08/23.
//

import Foundation

class ProductDetailsViewModel: ObservableObject {
    private let productName: String
    private let productDescription: String
    private let productPrice: Double
    private let productRating: Double
    private let productCategory: String
    private let productImageURL: String
    
    init(productName: String, productDescription: String, productPrice: Double, productRating: Double, productCategory: String, productImageURL: String) {
        self.productName = productName
        self.productDescription = productDescription
        self.productPrice = productPrice
        self.productRating = productRating
        self.productCategory = productCategory
        self.productImageURL = productImageURL
    }
    
    func getProductName() -> String{
        return productName
    }
    
    func getProductDescription() -> String{
        return productDescription
    }
    
    func getProductCategory() -> String{
        return productCategory.capitalized
    }
    
    func getProductImageURL() -> String{
        return productImageURL
    }
    
    func getProductPrice() -> Double{
        return productPrice
    }
    
    func getProductRating() -> Double{
        return productRating
    }
    
    
}
