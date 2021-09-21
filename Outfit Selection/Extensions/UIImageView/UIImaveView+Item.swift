//
//  UIImageView+Item.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 21.09.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import UIKit

extension UIImageView {
    // MARK: - Computed Properties
    /// Item whose image is being displayed by image view
    var item: Item? {
        get { itemImage?.item }
        set { itemImage?.item = newValue }
    }
    
    /// Image casted to item image
    var itemImage: ItemImage? { image as? ItemImage }
}
