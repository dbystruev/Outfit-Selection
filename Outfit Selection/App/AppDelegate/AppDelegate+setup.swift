//
//  AppDelegate+setup.swift
//  Outfit Selection
//
//  Created by Evgeniy Goncharov on 15.02.2022.
//  Copyright © 2022 Denis Bystruev. All rights reserved.
//

import Foundation
import UIKit

extension AppDelegate {
    //TODO: Add setting for profile
    
    /// Configure default settings
    func configureSettings(){
        
        // Set netral gender
        Gender.current = Gender.other

        // Load all collection of brand
        let brandedImages = BrandManager.shared.brandedImages
        brandedImages.forEach { $0.isSelected = true }
        
        // Load all occasions
        let occasions = Occasions.currentGender
        occasions.forEach { $0.isSelected = true }


    }
}
