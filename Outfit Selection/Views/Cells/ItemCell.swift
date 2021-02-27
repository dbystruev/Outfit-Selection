//
//  ItemCell.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 25.02.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import UIKit

/// Cell for wishlist items tab
class ItemCell: UICollectionViewCell {
    // MARK: - Outlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var pictureImageView: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var vendorLabel: UILabel!
    
    // MARK: - Methods
    /// Configure item cell content with a given item
    /// - Parameter item: item to configure cell content with
    func configure(with item: Item) {
        // Configure labels
        nameLabel.text = item.nameWithoutVendor
        priceLabel.text = item.price?.asPrice
        vendorLabel.text = item.vendor
        
        // Configure picture
        guard let url = item.pictures?.first else { return }
        NetworkManager.shared.getImage(url) { picture in
            guard let picture = picture else { return }
            DispatchQueue.main.async {
                self.pictureImageView.image = picture
            }
        }
    }
    
}
