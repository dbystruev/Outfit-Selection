//
//  Collection+categories.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 29.10.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

extension Swift.Collection where Element: BinaryInteger  {
    /// Return the list of categories
    var categories: Categories { compactMap { Categories.byID[Int($0)] }}
    
    /// Return category IDs and names joined by comma with space
    var categoriesDescription: String {
        categories.map { "\($0)" }.joined(separator: ", ")
    }
    
    /// Return category IDs joined by comma with space
    var categoryIDsDescription: String { categories.map { "\($0.id)" }.joined(separator: ", ") }
    
    /// Return category names joined by comma with space
    var categoryNamesDescription: String { categories.map { $0.name }.joined(separator: ", ") }
}
