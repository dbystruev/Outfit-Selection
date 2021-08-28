//
//  FeedItemCollectionViewLayout.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 28.08.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//
//  https://developer.apple.com/documentation/uikit/views_and_controls/collection_views/layouts/customizing_collection_view_layouts

import UIKit

class FeedItemCollectionViewLayout: UICollectionViewFlowLayout {
    /// New size set by viewWillTransition(to:with:)
    var sizeViewWillTransitionTo: CGSize?
    
    /// Called before each layout update
    override func prepare() {
        super.prepare()
        guard let collectionView = collectionView else { return }
        
        let availableWidth = collectionView.bounds.inset(by: collectionView.layoutMargins).width
        let maxNumColumns = FeedItemCollectionViewCell.cellsPerRow(for: sizeViewWillTransitionTo ?? collectionView.bounds.size)
        minimumInteritemSpacing = 16
        let cellWidth = (availableWidth / CGFloat(maxNumColumns) - minimumInteritemSpacing).rounded(.down)
        let cellHeight = 217 * cellWidth / 155
        
        itemSize = CGSize(width: cellWidth, height: cellHeight)
        sectionInset = UIEdgeInsets(top: minimumInteritemSpacing, left: 0, bottom: 0, right: 0)
        sectionInsetReference = .fromSafeArea
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        guard let collectionView = collectionView else { return false }
        return !newBounds.size.equalTo(collectionView.bounds.size)
    }
}
