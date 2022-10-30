//
//  CartsView.swift
//  ProductsDemo
//
//  Created by Kris Lin on 2022/10/30.
//

import SwiftUI
import Kingfisher

struct CartsView: View {
    @State var carts: [CartDao] = []
    var body: some View {
        List(carts, id: \.createdAt) { cart in
            HStack {
                if let product = cart.product {
                    KFImage(URL(string: product.thumbnail))
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100)
                    
                    let binding = Binding<Int>(get: {
                        cart.quantity
                    }, set: {
                        try? LocalCartsManager.shared.addToCart(product.id, quantity: $0)
                    })
                    VStack(alignment: .leading) {
                        Text(product.title)
                        QuantitySelectionView(selectedQuantity: binding, limit: product.stock)
                    }
                }
                
            }
        }
        .onAppear {
            carts = (try? LocalCartsManager.shared.getCarts()) ?? []
        }
    }
    
}

struct CartsView_Previews: PreviewProvider {
    static var previews: some View {
        CartsView()
    }
}
