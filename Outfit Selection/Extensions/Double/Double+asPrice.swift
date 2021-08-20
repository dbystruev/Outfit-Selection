//
//  Double+asPrice.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 17.11.2020.
//  Copyright © 2020 Denis Bystruev. All rights reserved.
//

import Foundation

extension Double {
    var asPrice: String {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.numberStyle = .currency
        guard let fullAmount = formatter.string(from: NSNumber(value: self)) else { return "\(Int(self.rounded())) ₽" }
        return String(fullAmount.dropLast(5)) + " ₽"
    }
}
