//
//  FeedBrandCell.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 25.08.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import UIKit

class FeedBrandCell: FeedItemCell {
    // MARK: - Outlets
    @IBOutlet weak var brandsCollectionView: UICollectionView!
    
    // MARK: - Class Properties
    class override var designFactor: CGFloat { 1 }
    
    /// Default item sizes
    class override var itemHeight: CGFloat { 98 * designFactor }
    class override var itemWidth: CGFloat { 98 * designFactor }
    
    /// Default cell's height
    class override var height: CGFloat { 282 * designFactor }
    
    // MARK: - Stored Properties
    /// The collection of brand images
    let brandedImages = BrandManager.shared.brandedImages
    
    // MARK: - Inherited Methods
    /// Called when we know for sure what items we want to display
    /// - Parameters:
    ///   - kind: cell's type
    ///   - items: the brands which needs to be displayed in the item stack view
    override func configureContent(for kind: FeedItemCell.Kind, items: [Item]) {
        // Check that we indeed were passed brands kind, otherwise configure with super
        guard kind == .brands else {
            super.configureContent(for: kind, items: items)
            return
        }
        
        // Configure variables
        self.kind = kind
        
        // Items could be ignored for feed brand cell
        
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
