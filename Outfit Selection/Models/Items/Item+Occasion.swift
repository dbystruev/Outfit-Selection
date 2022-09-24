//
//  Item+Occasion.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 28.10.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

extension Item {
    // MARK: - Methods
    /// Returns category ID if it is present in occasion, nil if not
    /// - Parameter occasion: the occasion to check
    /// - Returns: item's category ID if it is also present in occasion, nil if not
    func categoryID(in occasion: Occasion) -> Int? {
        occasion.categoryIDs.contains(categoryID) ? categoryID : nil
    }
    
    /// Returns category if it is present in occasion, nil if not
    /// - Parameter occasion: the occasion to check
    /// - Returns: item's category if it is present in occasion, nil if not
    func category(in occasion: Occasion) -> Category? {
        guard let categoryID = categoryID(in: occasion) else { return nil }
        return Categories.byID[categoryID]
    }
    
    /// Returns true if item has any subcategory IDs matching given, false otherwise
    /// - Parameter occasionSubcategoryIDs: occasion subcategory IDs to match
    /// - Returns: true if any item's subcategory ID matches one of the given
    func isMatching(_ occasionSubcategoryIDs: [Int]) -> Bool {
        !subcategoryIDs(in: occasionSubcategoryIDs).isEmpty
    }
    
    /// Returns the set of subcategory IDs present both in item and in the given list of IDs
    /// - Parameter IDs: the list of subcategory IDs to check
    /// - Returns: the set of subcategory IDs present both in item and in the given list of IDs
    func subcategoryIDs(in IDs: [Int]) -> Set<Int> {
        Set(subcategoryIDs).intersection(IDs)
    }
    
    /// Returns the set of subcategory IDs present both in item and in occasion
    /// - Parameter occasion: the occasion to check
    /// - Returns: the set of subcategory IDs present both in item and in occasion
    func subcategoryIDs(in occasion: Occasion) -> Set<Int> {
        subcategoryIDs(in: occasion.flatSubcategoryIDs)
    }
    
    /// Returns the list of subcategories present both in item and in the given list of subcategory IDs
    /// - Parameter IDs: the list of subcategory IDs to check
    /// - Returns: the list of categories present both in item and in the given list of subcategory IDs
    func subcategories(in IDs: [Int]) -> Categories {
        subcategoryIDs(in: IDs).categories
    }
    
    /// Returns subcategories present both in item and in occasion
    /// - Parameter occasion: the occasion to check
    /// - Returns: subcategories present both in item and in occasion
    func subcategories(in occasion: Occasion) -> Categories {
        subcategoryIDs(in: occasion).categories
    }
}
