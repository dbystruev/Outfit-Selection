//
//  BrandedImage.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 27.11.2020.
//  Copyright © 2020 Denis Bystruev. All rights reserved.
//

import UIKit

class BrandedImage: UIImage {
    /// The name of the brand
    var brandName = ""
    
    /// Whether this brand image is selected
    var isSelected = false {
        didSet {
            BrandManager.shared.saveSelectedBrands()
        }
    }
    
    /// Tag for the scroll view
    var tag = 0
}
