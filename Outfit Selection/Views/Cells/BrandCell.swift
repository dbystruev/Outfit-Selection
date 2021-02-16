//
//  BrandCell.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 27.11.2020.
//  Copyright © 2020 Denis Bystruev. All rights reserved.
//

import UIKit

class BrandCell: UICollectionViewCell {
    // MARK: - Static Properties
    /// Padding around brand image view in the cell
    static let padding: CGFloat = 20
    
    // MARK: - Outlets
    @IBOutlet weak var brandImageView: UIImageView!
    @IBOutlet weak var brandImageViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var brandImageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var brandImageViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var brandImageViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var brandImageViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var brandImageViewWidthConstraint: NSLayoutConstraint!
    
    /// Constraints surrounding brand image view in the cell
    var paddingConstraints: [NSLayoutConstraint] {
        [brandImageViewBottomConstraint, brandImageViewLeadingConstraint, brandImageViewTopConstraint, brandImageViewTrailingConstraint]
    }
}
