//
//  Branded.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 14.12.2020.
//  Copyright © 2020 Denis Bystruev. All rights reserved.
//

/// Protocol with brand and branded method
protocol Branded {
    /// The brand
    var brand: String? { get }
    
    /// Returns true if item's brand includes one of the given brand names
    /// - Parameter brandNames: the names of the brands to search for
    /// - Returns: true if brand name is found, false otherwise
    func branded(_ brandNames: [String]) -> Bool
}

// MARK: - Default Implementation
extension Branded {
    func branded(_ brandNames: [String]) -> Bool {
        // If no brand names are given anything matches
        guard !brandNames.isEmpty else { return true }
        
        // If brand names are given but vendor is nil nothing matches
        guard let brand = brand?.lowercasedLetters else { return false }
        
        // Otherwise check if brand contains one of the brand names
        return brandNames.contains { brand.contains($0.lowercasedLetters) }
    }
}
