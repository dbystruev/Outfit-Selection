//
//  Occasions.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 27.10.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

typealias Occasions = [Occasion]

extension Occasions {
    /// Occasions filtered by current gender
    var currentGender: Occasions {
        filter {
            // If current gender is not set all occasions are OK
            guard let currentGender = Gender.current else { return true }
            
            // For unisex all occasions are OK, otherwise match occasion gender
            return $0.gender == currentGender || .other == currentGender
        }
    }
}
