//
//  WishlistOutfitCell.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 25.02.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import UIKit

class WishlistOutfitCell: WishlistBaseCell {
    
    // MARK: - Outlets
    @IBOutlet weak var occasionLabel: UILabel!
    @IBOutlet var pictureImageViews: [UIImageView]!
    @IBOutlet weak var priceLabel: UILabel!
    
    // MARK: - Methods
    /// Configure outfit cell content with wishlist outfit
    /// - Parameters:
    ///   - outfit: the wishlist outfit
    ///   - delegate: delegate to send message about select button tap, nil by default
    func configure(with outfit: WishlistItemCatalog, delegate: ButtonDelegate? = nil) {
        // Save the delegate and the outfit
        super.configure(with: outfit, delegate: delegate)
        
        // Configure labels
        occasionLabel.text = outfit.name
        priceLabel.text = outfit.price.asPrice
        
        // Sorter items value
        let sorteredItem = outfit.itemIDs.compactMap { id in
            outfit.items.first { $0.value.id == id }
        }
        
        // Configure pictures
        for (item, pictureImageView) in zip(sorteredItem, pictureImageViews) {
            //debug(item.value.id, pictureImageView.tag )
            
            pictureImageView.image = nil
            pictureImageView.configure(with: item.value.pictures.first)
        }
    }
}
