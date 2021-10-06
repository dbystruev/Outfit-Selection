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
    var brandName: String?
    
    /// Sets whether this brand image is selected without updating user defaults
    private var _isSelected: Bool?
    
    /// True if this branded image was last selected by the user
    var isLastSelected: Bool {
        BrandManager.shared.lastSelected == self
    }
    
    /// Sets whether this brand image is selected and update user defaults
    var isSelected: Bool {
        get { _isSelected ?? false }
        set {
            guard newValue != _isSelected else { return }
            _isSelected = newValue
            let brandManager = BrandManager.shared
            brandManager.saveSelectedBrands()
            if newValue {
                brandManager.lastSelected = self
            }
        }
    }
}
