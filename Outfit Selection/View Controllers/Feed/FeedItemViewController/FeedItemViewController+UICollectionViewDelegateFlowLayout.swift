//
//  FeedItemViewController+UICollectionViewDelegateFlowLayout.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 27.08.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import UIKit

extension FeedItemViewController: UICollectionViewDelegateFlowLayout {
    // MARK: - Helper Methods
    /// Calculates cell size for the given collection view
    /// - Parameter collectionView: the collection view to calculate cell size for
    /// - Returns: calculated cell size
    func cellSize(for collectionView: UICollectionView) -> CGSize {
        let size = collectionView.bounds.size
        let cellWidth = floor(size.width / CGFloat(FeedItemCollectionViewCell.cellsPerRow(for: size)))
        let cellHeight = 217 * cellWidth / 155
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout Methods
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        cellSize(for: collectionView)
    }
}
