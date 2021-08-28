//
//  BrandCell.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 27.11.2020.
//  Copyright © 2020 Denis Bystruev. All rights reserved.
//

import UIKit

class BrandCell: UICollectionViewCell {
    // MARK: - Class Properties
    /// Nib name is the same as the class name
    class var nibName: String { String(describing: Self.self) }
    
    // MARK: - Static Properties
    /// Horizontal margin between brand image view container and the cell
    static var horizontalMargin: CGFloat = 12
    
    /// Horizontal padding around brand image view and its container
    static var horizontalPadding: CGFloat = 8
    
    /// The nib object containing this brand cell
    static let nib = UINib(nibName: nibName, bundle: nil)
    
    /// The reuse identifier to associate with this cell's nib file
    static let reuseId = "brandCell"
    
    /// Vertical margin between brand image view container and the container
    static var verticalMargin: CGFloat = 8
    
    /// Vertical padding around brand image view and its container
    static var verticalPadding: CGFloat = 24
    
    // MARK: - Static Methods
    /// Returns the number of cells to fit in one row
    /// - Parameter size: size of a view to determine landscape or portrait orientation
    /// - Returns: the number of cells to fit in one row
    static func cellsPerRow(for size: CGSize) -> Int {
        // Fit 6 cells horizontally or 3 cells vertically
        size.height < size.width ? 6 : 3
    }
    
    // MARK: - Outlets
    /// Bottom margin constraint around brand image view container and the cell
    @IBOutlet weak var bottomMarginConstraint: NSLayoutConstraint!
    
    /// Bottom padding constraint around brand image view and its container
    @IBOutlet weak var bottomPaddingConstraint: NSLayoutConstraint!
    
    /// Container view around brand image view
    @IBOutlet weak var brandImageContainerView: UIView!
    
    /// Image view with the brand logo
    @IBOutlet weak var brandImageView: UIImageView!
    
    /// Height constraint for the brand image view
    @IBOutlet weak var brandImageViewHeightConstraint: NSLayoutConstraint!
    
    /// Width constrainer for the brand image view
    @IBOutlet weak var brandImageViewWidthConstraint: NSLayoutConstraint!
    
    /// Image view with the checkmark icon
    @IBOutlet weak var checkmarkImageView: UIImageView!
    
    /// Leading margin constraint around brand image view container and the cell
    @IBOutlet weak var leadingMarginConstraint: NSLayoutConstraint!
    
    /// Leading padding constraint around brand image view and its container
    @IBOutlet weak var leadingPaddingConstraint: NSLayoutConstraint!
    
    /// Top margin constraint around brand image view container and the cell
    @IBOutlet weak var topMarginConstraint: NSLayoutConstraint!
    
    /// Top padding constraint around brand image view and its container
    @IBOutlet weak var topPaddingConstraint: NSLayoutConstraint!
    
    /// Trailing margin constraint around brand image view container and the cell
    @IBOutlet weak var trailingMarginConstraint: NSLayoutConstraint!
    
    /// Trailing padding constraint around brand image view and its container
    @IBOutlet weak var trailingPaddingConstraint: NSLayoutConstraint!
    
    // MARK: - Outlet Collections
    /// Horizontal margin constraints surrounding brand image view in the cell
    var horizontalMarginConstraints: [NSLayoutConstraint] { [leadingMarginConstraint, trailingMarginConstraint] }
    
    /// Horizontal padding constraints surrounding brand image view in the cell
    var horizontalPaddingConstraints: [NSLayoutConstraint] { [leadingPaddingConstraint, trailingPaddingConstraint] }
    
    /// Vertical margin constraints surrounding brand image view in the cell
    var verticalMarginConstraints: [NSLayoutConstraint] { [bottomMarginConstraint, topMarginConstraint] }
    
    /// Vertical padding constraints surrounding brand image view in the cell
    var verticalPaddingConstraints: [NSLayoutConstraint] { [bottomPaddingConstraint, topPaddingConstraint] }
    
    // MARK: - Methods
    /// Configure brand cell with given branded image
    /// - Parameters:
    ///   - brandedImage: the branded image to configure the brand cell with
    ///   - cellSize: the size of the branded collection view cell
    func configure(brandedImage: BrandedImage, cellSize: CGSize) {
        // Configure brand image view
        brandImageView.image = brandedImage
        
        // Configure horizontal and vertical margin and padding around constraints
        horizontalMarginConstraints.forEach { $0.constant = BrandCell.horizontalMargin }
        horizontalPaddingConstraints.forEach { $0.constant = BrandCell.horizontalPadding }
        verticalMarginConstraints.forEach { $0.constant = BrandCell.verticalMargin }
        verticalPaddingConstraints.forEach { $0.constant = BrandCell.verticalPadding }
        
        // Set min brand image view height and width
        brandImageViewHeightConstraint.constant = cellSize.height - 2 * (BrandCell.verticalMargin + BrandCell.verticalPadding)
        brandImageViewWidthConstraint.constant = cellSize.width - 2 * (BrandCell.horizontalMargin + BrandCell.horizontalPadding)
        
        // Need to layout constraints before configuring cell background
        layoutIfNeeded()
        
        // Configure cell background and border
        configureBackground(isSelected: brandedImage.isSelected)
    }
    
    /// Configure cell's background depending on whether the image is selected or not
    /// - Parameter isSelected: true if image is selected, false otherwise
    func configureBackground(isSelected: Bool) {
        // Set container view background color
        brandImageContainerView.backgroundColor = isSelected ? #colorLiteral(red: 0.7878249884, green: 0.8170605302, blue: 0.8061822057, alpha: 1) : .clear
        
        // Make corners round
        brandImageContainerView.layer.cornerRadius = brandImageContainerView.frame.size.width / 2
        
        // Show / hide checkmark image view depending on selection
        checkmarkImageView.isHidden = !isSelected
    }
}
