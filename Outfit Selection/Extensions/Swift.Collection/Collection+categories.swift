//
//  Swift.Collection+categories.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 29.10.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

extension Swift.Collection where Element: BinaryInteger  {
    /// Get categories from IDs
    var categories: Categories { compactMap { Categories.byID[Int($0)] }}
}
