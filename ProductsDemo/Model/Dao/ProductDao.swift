//
//  ProductDao.swift
//  ProductsDemo
//
//  Created by Kris Lin on 2022/10/30.
//

import Foundation
import RealmSwift
import SwiftUI

class ProductDao: Object {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var title: String
    @Persisted var detail: String
    @Persisted var price: Double
    @Persisted var discountPercentage: Double
    @Persisted var rating: Double
    @Persisted var stock: Int
    @Persisted var brand: String
    @Persisted var thumbnail: String
    @Persisted var thumbnails: String
    @Persisted(originProperty: "product") var cart: LinkingObjects<CartDao>

}
