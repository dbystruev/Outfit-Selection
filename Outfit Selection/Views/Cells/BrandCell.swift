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
    /// Number of cells to fit in one row
    static var cellsPerRow = 3
    
    /// Horizontal padding around brand image view in the cell
    static let horizontalPadding: CGFloat = 8
    
    /// Vertical padding around brand image view in the cell
    static let verticalPadding: CGFloat = 24
    
    // MARK: - Outlets
    @IBOutlet weak var brandImageView: UIImageView!
    @IBOutlet weak var brandImageViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var brandImageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var brandImageViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var brandImageViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var brandImageViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var brandImageViewWidthConstraint: NSLayoutConstraint!
    
    /// Horizontal padding constraints surrounding brand image view in the cell
    var horizontalPaddingConstraints: [NSLayoutConstraint] {
        [brandImageViewLeadingConstraint, brandImageViewTrailingConstraint]
    }
    
    /// Vertical padding constraints surrounding brand image view in the cell
    var verticalPaddingConstraints: [NSLayoutConstraint] {
        [brandImageViewBottomConstraint, brandImageViewTopConstraint]
    }
    
    // MARK: - Methods
    /// Configure brand cell with given branded image
    /// - Parameter brandedImage: the branded image to configure the brand cell with
    func configure(brandedImage: BrandedImage, in collectionView: UICollectionView) {
        brandImageView.alpha = brandedImage.isSelected ? 1 : 0.25
        brandImageView.image = brandedImage
        
        // Configure horizontal and vertical padding around brand image view
        horizontalPaddingConstraints.forEach { $0.constant = BrandCell.horizontalPadding }
        verticalPaddingConstraints.forEach { $0.constant = BrandCell.verticalPadding }
        
        // Set min brand image view height and width
        let cellSide = (collectionView.bounds.size.width - 32) / CGFloat(BrandCell.cellsPerRow)
        brandImageViewHeightConstraint.constant = cellSide - 2 * BrandCell.verticalPadding
        brandImageViewWidthConstraint.constant = cellSide - 2 * BrandCell.horizontalPadding
    }
}
