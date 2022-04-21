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
    @IBOutlet weak var chevronImageView: UIImageView!
    @IBOutlet weak var occasionNameLabel: UILabel!
    
    // MARK: - Methods
    /// Configure occasioncheckBox
    /// - Parameters:
    ///   - occasion: the occasion to confiture cell with
    func configure(
        with occasion: Occasion,
        hideCheckBox: Bool = false,
        hideChevron: Bool = true,
        custtomLabel: String = "") {
            checkBoxImageView.isHighlighted = occasion.isSelected
            checkBoxImageView.isHidden = hideCheckBox
            chevronImageView.isHidden = hideChevron
            occasionNameLabel.text = custtomLabel.isEmpty ? occasion.title : custtomLabel
        }
}

