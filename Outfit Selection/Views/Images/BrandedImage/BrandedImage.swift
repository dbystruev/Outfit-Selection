//
//  BrandedImage.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 27.11.2020.
//  Copyright © 2020 Denis Bystruev. All rights reserved.
//

import UIKit

class BrandedImage: UIImage {
    // MARK: - Stored Properties
    /// The name of the brand
    var brandName = ""
    
    /// Sets whether this brand image is selected without updating user defaults
    var _isSelected: Bool?
    
    /// Sets whether this brand image is selected and update user defaults
    var isSelected: Bool {
        get { _isSelected ?? false }
        set {
            guard newValue != _isSelected else { return }
            _isSelected = newValue
            BrandManager.shared.saveSelectedBrands()
        }
    }
    
    /// Tag for the scroll view
    var tag = 0
}
