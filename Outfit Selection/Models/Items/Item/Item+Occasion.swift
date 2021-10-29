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
    
    /// Returns the set of subcategory IDs present both in item and in the given list of IDs
    /// - Parameter IDs: the list of IDs to check
    /// - Returns: the set of subcategory IDs present both in item and in the given list of IDs
    func subcategoryIDs(in IDs: [Int]) -> Set<Int> {
        Set(subcategoryIDs).intersection(IDs)
    }
    
    /// Returns the set of subcategory IDs present both in item and in occasion
    /// - Parameter occasion: the occasion to check
    /// - Returns: the set of subcategory IDs present both in item and in occasion
    func subcategoryIDs(in occasion: Occasion) -> Set<Int> {
        subcategoryIDs(in: occasion.subcategoryIDs)
    }
    
    func subcategories(in IDs: [Int]) -> Categories {
        subcategoryIDs(in: IDs).compactMap { Categories.byID[$0] }
    }
    
    /// Returns subcategories present both in item and in occasion
    /// - Parameter occasion: the occasion to check
    /// - Returns: subcategories present both in item and in occasion
    func subcategories(in occasion: Occasion) -> Categories {
        subcategoryIDs(in: occasion).compactMap { Categories.byID[$0] }
    }
}
