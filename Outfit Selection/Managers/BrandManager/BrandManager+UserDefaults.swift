//
//  BrandManager+UserDefaults.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 08.09.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import Foundation

extension BrandManager {
    // MARK: - Static Constants
    /// User defaults key
    static let userDefaultsKey = "GetOutfitSelectedBrandsKey"
    
    // MARK: - Methods
    /// Load selected brands from user defaults and update branded images
    func loadSelectedBrands(into brandedImages: BrandedImages?) {
        guard let selectedBrands = UserDefaults.standard.object(forKey: BrandManager.userDefaultsKey) as? [String] else { return }
        guard !selectedBrands.isEmpty else { return }
        brandedImages?.forEach { $0._isSelected = $0.branded(selectedBrands) }
    }
    
    /// Save selected brands to user defaults
    func saveSelectedBrands() {
        UserDefaults.standard.set(Array(selectedBrands), forKey: BrandManager.userDefaultsKey)
    }
}
