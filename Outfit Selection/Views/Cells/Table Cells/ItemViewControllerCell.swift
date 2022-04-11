//
//  ItemViewControllerCell.swift
//  Outfit Selection
//
//  Created by Evgeniy Goncharov on 08.04.2022.
//  Copyright © 2022 Denis Bystruev. All rights reserved.
//

import UIKit

class ItemViewControllerCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: - Custom Methods
    /// Configures this cell with item
    /// - Parameter occasion: the occasion to configure this cell with
    func configureContent(with item: Item) {
        /// Set image to itemImage
        itemImage.configure(with: item.pictures.first)
        /// Set  price to priceLabel
        priceLabel.text = item.price.asPrice
        /// Set brand with name to titleLabel
        titleLabel.text = "\(item.brand ?? "") \(item.name)"
    }
}
