//
//  Occasions.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 27.10.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import Algorithms

typealias Occasions = [Occasion]

extension Occasions {
    // MARK: - Computed Properties
    /// True if array or occasions is empty, false otherwise
    var areEmpty: Bool { isEmpty }
    
    /// Item IDs from top left clockwise matching cornered subcategory IDs
    var corneredItemIDs: [[String]] {
        // Array where we accumulate items from different corners
        var corneredItemIDs = [[String]](repeating: [], count: count)
        
        // Go through each corner from top left clockwise
        for cornerIndex in 0 ..< count {
            let itemIDs = compactMap { $0.corneredItemIDs[safe: cornerIndex] }
                .flatMap { $0 }
                .uniqued()
            corneredItemIDs[cornerIndex] = [String](itemIDs)
        }
        
        return corneredItemIDs
    }
    
    /// Occasions filtered by current gender
    var currentGender: Occasions {
        filter {
            // If current gender is not set all occasions are OK
            guard let currentGender = Gender.current else { return true }
            
            // For unisex all occasions are OK, otherwise match occasion gender
            return $0.gender == currentGender || .other == currentGender
        }
    }
    
    /// First occasion which is selected
    var firstSelected: Occasion? {
        selected.first
    }
    
    /// Unique flat subcategory IDs for all occasions
    var flatSubcategoryIDs: [Int] {
        [Int](flatMap { $0.flatSubcategoryIDs }.uniqued())
    }
    
    /// All selected occasions
    var selected: Occasions {
        filter { $0.isSelected }
    }
    
    /// All occasions, but selected are first
    var selectedFirst: Occasions {
        selected + unselected
    }
    
    /// The set of titles (name: label) of all occasions
    var titles: Set<String> { Set(map { $0.title })}
    
    /// All unselected occasions
    var unselected: Occasions {
        filter { !$0.isSelected }
    }
}
