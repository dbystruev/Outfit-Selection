//
//  OutfitCell.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 25.02.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import UIKit

class OutfitCell: UICollectionViewCell {
    // MARK: - Outlets
    @IBOutlet weak var occasionLabel: UILabel!
    @IBOutlet var pictureImageViews: [UIImageView]!
    @IBOutlet weak var priceLabel: UILabel!
    
    // MARK: - Methods
    /// Configure outfit cell content with wishlist outfit
    /// - Parameter outfit: the wishlist outfit
    func configure(with outfit: Wishlist) {
        // Configure labels
        occasionLabel.text = outfit.occasion
        priceLabel.text = outfit.price.asPrice
        
        // Configure pictures
        for (item, pictureImageView) in zip(outfit.items, pictureImageViews) {
            pictureImageView.image = nil
            guard let url = item.pictures?.first else { continue }
            NetworkManager.shared.getImage(url) { picture in
                guard let picture = picture else { return }
                DispatchQueue.main.async {
                    pictureImageView.image = picture
                }
            }
        }
    }
}
