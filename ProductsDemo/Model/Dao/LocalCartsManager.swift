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
        let products = realm.objects(CartDao.self)
        notificationToken = products.observe {[weak self] changes in
            switch changes {
            case .initial:
                self?.observers.forEach { _, block in
                    block()
                }
            case .update(_, _, _, _):
                self?.observers.forEach { _, block in
                    block()
                }
            case .error(_):
                break
            }
        }
        
    }
    //TODO: removeCart
    
    func addToCart(_ productId: Int, quantity: Int) throws {
        let realm = try Realm()
        guard let product = realm.objects(ProductDao.self).where ({$0.id == productId}).first else {
            return
        }
        try realm.write {
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
                realm.add(cart)
            }
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
