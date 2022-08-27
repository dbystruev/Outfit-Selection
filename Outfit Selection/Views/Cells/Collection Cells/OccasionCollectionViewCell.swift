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
    ///   - occasion: the occasion to configure the cell with (optional)
    ///   - hideCheckBox: true if check box has to be hidden
    ///   - hideChevron: true if chevron has to be hidden
    ///   - customLabel: nil by default. If not nil, use instead of occasion.title
    func configure(
        with occasion: Occasion? = nil,
        hideCheckBox: Bool = false,
        hideChevron: Bool = true,
        customLabel: String? = nil
    ) {
        checkBoxImageView.isHighlighted = occasion?.isSelected == true
        checkBoxImageView.isHidden = hideCheckBox
        chevronImageView.isHidden = hideChevron
        occasionNameLabel.text = customLabel ?? occasion?.title
    }
}

