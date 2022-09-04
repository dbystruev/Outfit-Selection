//
//  Double+asPrice.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 17.11.2020.
//  Copyright © 2020 Denis Bystruev. All rights reserved.
//

import Foundation

extension Double {
    /// Return double value as currency with a currency symbol
    /// - Parameter feedID: a feed ID with 3-part suffix, like "ae.en.aed" or "ru.ru.rub"
    /// - Returns: value as currency with a currency symbol
    func asPrice(feedID: String? = nil) -> String {
        let failbackPrice = "\(Int(rounded()))"
        guard let feedID = feedID else { return failbackPrice }
        let countryLanguageCurrency = feedID.split(separator: ".")
        let count = countryLanguageCurrency.count
        guard 2 < count else { return failbackPrice }
        let country = countryLanguageCurrency[count - 3]    // "ae" or "ru"
        let language = countryLanguageCurrency[count - 2]   // "en" or "ru"
        let currency = countryLanguageCurrency[count - 1]   // "aed" or "rub"
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "\(language)_\(country.uppercased())")
        formatter.currencyCode = currency.uppercased()
        formatter.maximumFractionDigits = Int(100 * self) % 100 == 0 ? 0 : 2
        formatter.numberStyle = .currency
        guard let fullAmount = formatter.string(from: NSNumber(value: self)) else {
            return failbackPrice
        }
        return fullAmount
    }
}
