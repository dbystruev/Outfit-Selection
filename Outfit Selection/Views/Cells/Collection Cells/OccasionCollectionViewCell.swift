//
//  OccasionCollectionViewCell.swift
//  Outfit Selection
//
//  Created by Evgeniy Goncharov on 18.04.2022.
//  Copyright © 2022 Denis Bystruev. All rights reserved.
//

import UIKit

class OccasionCollectionViewCell: UICollectionViewCell {
    // MARK: - Outlets
    @IBOutlet weak var checkBoxImageView: UIImageView!
    @IBOutlet weak var occasionNameLabel: UILabel!
    
    // MARK: - Methods
    /// Configure occasion
    /// - Parameters:
    ///   - occasion: the occasion to confiture cell with
    func configure(with occasion: Occasion) {
        checkBoxImageView.isHighlighted = occasion.isSelected
        occasionNameLabel.text = occasion.title
    }
}

