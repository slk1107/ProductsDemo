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
            List(model.products) { product in
                HStack {
                    KFImage(product.thumbnail)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100)
                    
                    VStack(alignment: .leading) {
                        Text(product.title)
                        Text("Brand: \(product.brand)")
                        Text(product.detail)
                        HStack {
                            Button(action: {
                                let selectedQuantity = product.selectedQuantity
                                if selectedQuantity > 1 {
                                    model.updateQuantity(selectedQuantity - 1, by: product.id)
                                }
                            }, label: {
                                Image(systemName: "minus.circle")
                            })
                            .buttonStyle(.borderless)
                            
                            Text("\(product.selectedQuantity)")
                            
                            Button(action: {
                                let selectedQuantity = product.selectedQuantity
                                if selectedQuantity < product.stock {
                                    model.updateQuantity(selectedQuantity + 1, by: product.id)
                                }
                            }, label: {
                                Image(systemName: "plus.circle")
                            })
                            .buttonStyle(.borderless)
                            
                            Spacer()
                            
                            Button(action: {
                                
                            }, label: {
                                Text("Add to cart")
                            })
                            .buttonStyle(.borderless)
                        }
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
