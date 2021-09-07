//
//  FeedBrandCell.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 25.08.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import UIKit

class FeedBrandCell: FeedBaseCell {
    // MARK: - Outlets
    @IBOutlet weak var brandsCollectionView: UICollectionView!
    
    // MARK: - Class Properties
    class override var designFactor: CGFloat { 1 }
    
    /// Default item sizes
    class override var itemHeight: CGFloat { 98 * designFactor }
    class override var itemWidth: CGFloat { 98 * designFactor }
    
    /// Default cell's height
    class override var height: CGFloat { 174 * designFactor }
    
    // MARK: - Stored Properties
    /// The collection of branded images
    let brandedImages = BrandManager.shared.brandedImages.selectedFirst
    
    // MARK: - Inherited Methods
    /// Called when we know for sure what items we want to display
    /// - Parameters:
    ///   - kind: cell's type
    ///   - items: the brands which needs to be displayed in the item stack view
    func configureContent() {
        // Configure variables
        self.kind = .brands
        
        // Configure outlets
        titleLabel.text = title
    }
    
    /// Called from awakeFromNib() in the beggining
    override func configureLayout() {
        brandsCollectionView.dataSource = self
        brandsCollectionView.delegate = self
        brandsCollectionView.register(BrandCell.nib, forCellWithReuseIdentifier: BrandCell.reuseId)
        
        // Don't show that this cell is selected
        selectionStyle = .none
        
        // Set horizontal scroll direction for brands collection view
        guard let layout = brandsCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        layout.scrollDirection = .horizontal
    }
}
