//
//  CartDao.swift
//  ProductsDemo
//
//  Created by Kris Lin on 2022/10/30.
//

import Foundation
import RealmSwift
import SwiftUI

class CartDao: Object {
    @Persisted var updatedAt: Date
    @Persisted var createdAt: Int8
    @Persisted var quantity: Int
    @Persisted var product: ProductDao?
}
