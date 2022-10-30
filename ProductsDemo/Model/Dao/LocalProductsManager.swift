//
//  LocalProductsManager.swift
//  ProductsDemo
//
//  Created by Kris Lin on 2022/10/30.
//

import Foundation
import RealmSwift
class LocalProductsManager {
    static let shared = LocalProductsManager()
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
    func fetchProducts(start: Int, limit: Int) throws -> [ProductDao] {
        let realm = try Realm()
        let products = realm.objects(ProductDao.self)
        
        return Array(products
            .sorted(by: {$0.id < $1.id})[start ..< min(limit, products.count)])
    }
    
    func saveProducts(_ products: [ProductDao]) throws {
        let realm = try Realm()
        try realm.write {
            products.forEach {
                realm.add($0, update: .modified)
            }
        }
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
