//
//  LocalCartsManager.swift
//  ProductsDemo
//
//  Created by Kris Lin on 2022/10/30.
//

import Foundation
import RealmSwift
class LocalCartsManager {
    static let shared = LocalCartsManager()
    private var notificationToken: NotificationToken?
    private var observers: [Int: () -> Void] = [:]

    init() {
        let realm = try! Realm()
        let products = realm.objects(ProductDao.self)
        notificationToken = products.observe {[weak self] changes in
            switch changes {
            case .initial:
                break
            case .update(_, _, _, _):
                self?.observers.forEach { _, block in
                    block()
                }
                break
            case .error(_):
                break
            }
        }
        
    }
    
    func addToCart(_ productId: Int, quantity: Int) throws {
        let realm = try Realm()
        guard let product = realm.objects(ProductDao.self).where ({$0.id == productId}).first else {
            return
        }
        
        let cart: CartDao
        if let existingCart = realm.objects(CartDao.self).where({
            $0.product.id == productId
        }).first {
            cart = existingCart
            cart.updatedAt = Date()
            cart.quantity = quantity
        } else {
            cart = CartDao()
            cart.createdAt = Date()
            cart.updatedAt = Date()
            cart.product = product
            cart.quantity = quantity
        }
        
        try realm.write {
            realm.add(cart, update: .modified)
        }
    }
    
    func getCarts() throws -> [CartDao] {
        let realm = try Realm()
        return Array(realm.objects(CartDao.self))
    }
    
    func addObserver(_ observer: AnyObject, forChange block: @escaping () -> Void) {
        let token = ObjectIdentifier(observer).hashValue
        observers[token] = block
    }
    
    func removeObserver(_ observer: AnyObject) {
        let token = ObjectIdentifier(observer).hashValue
        observers.removeValue(forKey: token)
    }
}
