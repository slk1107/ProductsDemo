//
//  CartsPageViewModel.swift
//  ProductsDemo
//
//  Created by Kris Lin on 2022/10/30.
//

import Foundation
class CartsPageViewModel: ObservableObject {
    @Published var carts: [CartDao] = []
    deinit {
        LocalCartsManager.shared.removeObserver(self)
    }
    init() {
        LocalCartsManager.shared.addObserver(self, forChange: { [self] in
            setupCarts()
        })
        setupCarts()
        
    }
    
    func setupCarts() {
        carts = (try? LocalCartsManager.shared.getCarts()) ?? []
    }
    
    func updateCart(quantity:Int, productId: Int) {
        try? LocalCartsManager.shared.addToCart(productId, quantity: quantity)
    }
}
