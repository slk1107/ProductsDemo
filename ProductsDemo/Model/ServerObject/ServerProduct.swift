//
//  Product.swift
//  ProductsDemo
//
//  Created by Kris Lin on 2022/10/30.
//

import Foundation
import Alamofire
class API {
    static let products = URL(string: "https://dummyjson.com/products")!
}

class ProductsResponse: Decodable {
    var products: [Product]
    static func fetch() async throws -> [Product] {
        try await withUnsafeThrowingContinuation { continuation in
            AF.request(API.products, method: .get)
                .responseData { response in
                    if let data = response.data {
                        do {
                            let parsedResponse = try JSONDecoder().decode(ProductsResponse.self, from: data)
                            continuation.resume(returning: parsedResponse.products)
                            
                        } catch {
                            continuation.resume(throwing: error)
                        }
                        return
                    }
                    if let error = response.error {
                        continuation.resume(throwing: error)
                        return
                    }
                }
        }
    }
}

class Product: Decodable {
    let id: Int
    let title, productDescription: String
    let price: Int
    let discountPercentage, rating: Double
    let stock: Int
    let brand, category: String
    let thumbnail: String
    let images: [String]
    
    enum CodingKeys: String, CodingKey {
        case id, title
        case productDescription = "description"
        case price, discountPercentage, rating, stock, brand, category, thumbnail, images
    }
    
    
}
