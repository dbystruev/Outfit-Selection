//
//  AppDelegate+setup.swift
//  Outfit Selection
//
//  Created by Evgeniy Goncharov on 15.02.2022.
//  Copyright © 2022 Denis Bystruev. All rights reserved.
//

import UIKit

extension AppDelegate {
    
    /// Configure default settings
    func configureSettings(){
        
        // Check gender
        if (Gender.current == nil) {
            // Set netral gender
            Gender.current = Gender.other
        }
        
        // Load all collection of brand
        let brandedImages = BrandManager.shared.brandedImages
        if brandedImages.selected.count < 1 {
            brandedImages.forEach { $0.isSelected = true }
        }
        
        // Load all occasions
        let occasions = Occasions.currentGender
        if occasions.selected.count < 1 {
            occasions.forEach { $0.isSelected = true }
        }
    }
    
    /// Configure setting, load gender selected brands and occasion
    func restoreSettings() {
        
        // Restore collections from user defaults
        Collection.restore()
        
        // Restore gender from user defaults
        Gender.restore()
        
        // Load selected occasions
        let occasions = Occasions.currentGender
        let selectedOccasionTitles  = UserDefaults.selectedOccasionTitles
        for occasion in occasions {
            occasion.isSelected = selectedOccasionTitles.contains(occasion.title)
        }
        
        // Load selectred collection of brand
        let selectedBrands = UserDefaults.selectedBrands
        let brandedImages = BrandManager.shared.brandedImages
        for brand in brandedImages.images {
            brand.isSelected = selectedBrands.contains(brand.brandName ?? "")
        }
        
        // Restore wishlist from user defaults
        Wishlist.restore()
    }
}
