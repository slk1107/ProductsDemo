//
//  QuantitySelectionView.swift
//  ProductsDemo
//
//  Created by Kris Lin on 2022/10/30.
//

import SwiftUI

struct QuantitySelectionView: View {
    @Binding var selectedQuantity: Int
    var limit: Int
    var body: some View {
        HStack {
            Button(action: {
                if selectedQuantity > 1 {
                    selectedQuantity -= 1
                }
            }, label: {
                Image(systemName: "minus.circle")
            })
            .buttonStyle(.borderless)
            
            Text("\(selectedQuantity)")
            
            Button(action: {
                if selectedQuantity < limit {
                    selectedQuantity += 1
                }
            }, label: {
                Image(systemName: "plus.circle")
            })
            .buttonStyle(.borderless)
        }
    }
}

struct QuantitySelectionView_Previews: PreviewProvider {
    static var previews: some View {
        QuantitySelectionView(selectedQuantity: .constant(2), limit: 10)
    }
}
