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
        if BrandManager.shared.brandedImages.selected.count < 1 {
            brandedImages.forEach { $0.isSelected = true }
        }
        
        // Select all brands if app didn't start anytime
//        let brands = Brands.byName
//        debug(brands.selected.count)
//        if brands.selected.count < 1 {
//            brands.forEach { $0.value.isSelected = true }
//        }
        
        // Load all occasions
        let occasions = Occasions.currentGender
        if occasions.selected.count < 1 {
            occasions.forEach { $0.isSelected = true }
        }

    }
}
