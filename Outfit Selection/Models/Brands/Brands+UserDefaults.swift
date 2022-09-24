//
//  Brands+UserDefaults.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 09.03.2022.
//  Copyright © 2022 Denis Bystruev. All rights reserved.
//

import Foundation

extension Brands {
    // MARK: - Methods
    /// Load selected brands from user defaults and update the brands
    /// - Returns: the list of selected brands
    static func loadSelectedBrands() -> [String] {
        let selectedBrands = UserDefaults.selectedBrands
        update(selectedBrands: selectedBrands)
        return selectedBrands
    }
    
    /// Save selected brands to user defaults
    static func saveSelectedBrands() {
        guard !Brands.isEmpty else { return }
        UserDefaults.selectedBrands = Brands.selected.names
    }
}
