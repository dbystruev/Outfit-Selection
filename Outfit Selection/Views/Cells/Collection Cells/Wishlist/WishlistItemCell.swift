//
//  WishlistItemCell.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 25.02.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import UIKit

/// Cell for wishlist items tab
class WishlistItemCell: WishlistBaseCell {
    
    // MARK: - Outlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var pictureImageView: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var vendorLabel: UILabel!
    
    // MARK: - Methods
    /// Configure item cell content with a given item
    /// - Parameters:
    ///   - item:  item to configure cell content with
    ///   - delegate: delegate to send message about select button tap, nil by default
    func configure(with item: Item, delegate: ButtonDelegate? = nil) {
        // Save the delegate and the item
        super.configure(with: item, delegate: delegate)
        
        // Configure labels
        nameLabel.text = item.nameWithoutVendor
        priceLabel.text = item.price.asPrice
        vendorLabel.text = item.vendorName
        
        // Load the picture
        pictureImageView.configure(with: item.pictures.first)
    }
}
