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
    /// Configure gender cell with given gender
    /// - Parameters:
    ///   - gender: the gender to confiture cell with
    ///   - selected: gender which is currently selected
    func configure(with occasion: Occasion) {
        checkBoxImageView.isHighlighted = occasion.isSelected
        occasionNameLabel.text = occasion.title
    }
}

