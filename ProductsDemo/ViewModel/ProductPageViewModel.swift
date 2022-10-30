//
//  ProductPageViewModel.swift
//  ProductsDemo
//
//  Created by Kris Lin on 2022/10/30.
//

import Foundation

struct ProductCellModel: Identifiable {
    let id: Int
    let title: String
    let detail: String
    let price: Double
    let discountPercentage: Double
    let rating: Double
    let stock: Int
    let brand: String
    let thumbnail: URL?
    let thumbnails: [URL]
    
    var selectedQuantity = 0
    
    init(from product: ProductDao) {
        self.id = product.id
        self.title = product.title
        self.detail = product.detail
        self.price = product.price
        self.discountPercentage = product.discountPercentage
        self.rating = product.rating
        self.stock = product.stock
        self.brand = product.brand
        self.thumbnail = URL(string: product.thumbnail)
        self.thumbnails = product.thumbnails.components(separatedBy: ProductDao.imageSeparator).compactMap {
            URL(string: $0)
        }
    }
}

class ProductPageViewModel: ObservableObject {
    
    @Published var products: [ProductCellModel] = []
    private let pageSize = 10
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
            let results = try LocalProductsManager.shared.fetchProducts(start: 0, limit: Int.max)
            self.products = results.map {.init(from: $0)}
        } catch {
            
        }
    }
    
    func nextPage() {
        do {
            let results = try LocalProductsManager.shared.fetchProducts(start: products.count, limit: pageSize)
            if results.count > 0 {
                self.products.append(contentsOf: results.map {.init(from: $0)})
            } else {
                triggerServerUpdate(start: products.count, limit: pageSize)
            }
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
    
    func updateQuantity(_ quantity: Int, by id: Int) {
        if let index = products.firstIndex(where: {$0.id == id}) {
            products[index].selectedQuantity = quantity
        }
    }
    
    func addToCart(productId: Int) {
        guard  let q = products.first(where: {$0.id == productId})?.selectedQuantity else {
            return
        }
        try? LocalCartsManager.shared.addToCart(productId, quantity: q)
        updateQuantity(0, by: productId)
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
        self.thumbnail = product.thumbnail
        self.thumbnails = product.images.joined(separator: Self.imageSeparator)
    }
}
