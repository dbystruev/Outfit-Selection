//
//  Occasions.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 27.10.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

typealias Occasions = [Occasion]

extension Occasions {
    // MARK: - Computed Properties
    /// True if array or occasions is empty, false otherwise
    var areEmpty: Bool { isEmpty }
    
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
        self.first { $0.isSelected }
    }
}
