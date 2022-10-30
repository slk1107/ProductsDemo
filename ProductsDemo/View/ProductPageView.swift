//
//  ProductPageView.swift
//  ProductsDemo
//
//  Created by Kris Lin on 2022/10/30.
//

import SwiftUI
import Kingfisher

struct ProductPageView: View {
    @StateObject var model: ProductPageViewModel
    var body: some View {
        NavigationStack {
            List(Array(model.products.enumerated()), id: \.element.id) { index, product in
                HStack {
                    KFImage(product.thumbnail)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100)
                    
                    VStack(alignment: .leading) {
                        Text(product.title)
                            .font(.title2)
                        Text("Brand: \(product.brand)")
                        Text(product.detail)
                            .foregroundColor(.gray)
                        Text("Price: \(product.price.currency)")
                        Text("Stock: \(product.stock)")
                        
                        let binding = Binding<Int>(get: {
                            product.selectedQuantity
                        }, set: {
                            model.updateQuantity($0, by: product.id)
                        })
                        HStack {
                            QuantitySelectionView(selectedQuantity: binding, limit: product.stock)
                            Spacer()
                            
                            Button(action: {
                                model.addToCart(productId: product.id)
                            }, label: {
                                Text("Add to cart")
                            })
                            .buttonStyle(.borderless)
                        }
                    }
                    
                }
                .onAppear {
                    if index == model.products.count - 3 {
                        model.nextPage()
                    }
                }
            }
            
            .navigationTitle("Products")
            .toolbar {
                NavigationLink(destination: {
                    CartsView()
                }, label: { Image(systemName: "cart") })
            }
        }
        
        .onAppear {
            model.triggerServerUpdate(start: 0, limit: 10)
        }
    }
}

struct ProductPageView_Previews: PreviewProvider {
    static var previews: some View {
        ProductPageView(model: .init())
    }
}
