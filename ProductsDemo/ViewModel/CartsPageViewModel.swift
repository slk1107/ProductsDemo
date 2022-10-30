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
    }
    
    func setupCarts() {
        // TODO: Error handling
        carts = (try? LocalCartsManager.shared.getCarts()) ?? []
    }
    
    func updateCart(quantity:Int, productId: Int) {
        // TODO: Error handling
        try? LocalCartsManager.shared.addToCart(productId, quantity: quantity)
    }
}
