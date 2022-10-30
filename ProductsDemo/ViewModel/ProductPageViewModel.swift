//
//  ProductPageViewModel.swift
//  ProductsDemo
//
//  Created by Kris Lin on 2022/10/30.
//

import Foundation

struct ProductCellModel {
    let id: Int
    let title: String
    let detail: String
    let price: Double
    let discountPercentage: Double
    let rating: Double
    let stock: Int
    let brand: String
    let thumbnails: [URL]
    
    init(from product: ProductDao) {
        self.id = product.id
        self.title = product.title
        self.detail = product.detail
        self.price = product.price
        self.discountPercentage = product.discountPercentage
        self.rating = product.rating
        self.stock = product.stock
        self.brand = product.brand
        self.thumbnails = product.thumbnail.components(separatedBy: ProductDao.imageSeparator).compactMap {
            URL(string: $0)
        }
    }
}

class ProductPageViewModel: ObservableObject {
    
    @Published var products: [ProductCellModel] = []
    deinit {
        LocalProductsManager.shared.removeObserver(self)
    }
    init() {
        LocalProductsManager.shared.addObserver(self, forChange: { [self] in
            updateProductsFromDB()
        })
        updateProductsFromDB()
        
    }
    
    func updateProductsFromDB() {
        do {
            let results = try LocalProductsManager.shared.fetchProducts(start: 0, limit: products.count)
            self.products = results.map {.init(from: $0)}
        } catch {
            
        }
    }
    func triggerServerUpdate(start: Int, limit: Int) {
        // TODO: move this flow to ProductsManager
        Task {
            do {
                let results = try await ProductsResponse.fetch(start: start, limit: limit)
                try LocalProductsManager.shared.saveProducts(results.map {.init(from: $0)})
            }
            
        }
        
    }
}


extension ProductDao {
    static let imageSeparator = ","
    convenience init(from product: Product) {
        self.init()
        self.id = product.id
        self.title = product.title
        self.detail = product.productDescription
        self.price = product.price
        self.discountPercentage = product.discountPercentage
        self.rating = product.rating
        self.stock = product.stock
        self.brand = product.brand
        self.thumbnail = product.images.joined(separator: Self.imageSeparator)
    }
}
