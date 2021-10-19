//
//  BrandManager+UserDefaults.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 08.09.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import Foundation

extension BrandManager {
    // MARK: - Methods
    /// Load selected brands from user defaults and update branded images
    func loadSelectedBrands(into brandedImages: BrandedImages?) {
        let selectedBrands = UserDefaults.selectedBrands
        guard !selectedBrands.isEmpty else { return }
        brandedImages?.forEach { $0.isSelected = $0.branded(selectedBrands) }
    }
    
    /// Save selected brands to user defaults
    func saveSelectedBrands() {
        UserDefaults.selectedBrands = Array(selectedBrands)
    }
}
