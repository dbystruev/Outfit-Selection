//
//  Item+matches.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 18.11.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

extension Item {
    /// Returns true if item has any subcategory IDs matching given, false otherwise
    /// - Parameter subcategoryIDs: subcategory IDs to match
    /// - Returns: true if any item's subcategory ID matches one of the given
    func isMatching(_ subcategoryIDs: [Int]) -> Bool {
        !subcategories(in: subcategoryIDs).isEmpty
    }
}
