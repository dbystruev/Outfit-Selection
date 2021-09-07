//
//  FeedBrandCell+UICollectionViewDelegateFlowLayout.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 25.08.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import UIKit

extension FeedBrandCell: UICollectionViewDelegateFlowLayout {
    // MARK: - Helper Methods
    /// Calculates cell size for the given collection view
    /// - Parameter collectionView: the collection view to calculate cell size for
    /// - Returns: calculated cell size
    func cellSize(for collectionView: UICollectionView) -> CGSize {
        CGSize(width: FeedBrandCell.itemWidth, height: FeedBrandCell.itemHeight)
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout Methods
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        cellSize(for: collectionView)
    }
}
