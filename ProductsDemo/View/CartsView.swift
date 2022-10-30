//
//  CartsView.swift
//  ProductsDemo
//
//  Created by Kris Lin on 2022/10/30.
//

import SwiftUI
import Kingfisher

struct CartsView: View {
    @StateObject var model = CartsPageViewModel()
    var body: some View {
        List(model.carts, id: \.createdAt) { cart in
            HStack {
                if let product = cart.product {
                    KFImage(URL(string: product.thumbnail))
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100)
                    
                    let binding = Binding<Int>(get: {
                        cart.quantity
                    }, set: {
                        model.updateCart(quantity: $0, productId: product.id)
                    })
                    VStack(alignment: .leading) {
                        Text(product.title)
                            .font(.title3)
                        Text("Updated at: \(cart.updatedAt.formatted())")
                            .foregroundColor(.gray)
                        QuantitySelectionView(selectedQuantity: binding, limit: product.stock)
                    }
                }
                
            }
        }
        .navigationTitle("Shopping Cart")
        .onAppear {
            model.setupCarts()
        }
    }
    
}

struct CartsView_Previews: PreviewProvider {
    static var previews: some View {
        CartsView()
    }
}
