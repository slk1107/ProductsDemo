//
//  Number+helper.swift
//  ProductsDemo
//
//  Created by Kris Lin on 2022/10/30.
//

import Foundation
extension Double {
    var currency: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        if let result = formatter.string(from: self as NSNumber) {
            return result
        } else {
            return "\(self)"
        }
    }
}

