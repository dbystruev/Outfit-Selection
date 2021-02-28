//
//  BrandsViewController+UICollectionViewDelegateFlowLayout.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 16.02.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import UIKit

extension BrandsViewController: UICollectionViewDelegateFlowLayout {
    // MARK: - Helper Methods
    /// Calculates cell size for the given collection view
    /// - Parameter collectionView: the collection view to calculate cell size for
    /// - Returns: calculated cell size
    func cellSize(for collectionView: UICollectionView) -> CGSize {
        let size = collectionView.bounds.size
        let cellWidth = floor(size.width / CGFloat(BrandCell.cellsPerRow(for: size)))
        let cellHeight = cellWidth - 2 * (BrandCell.horizontalMargin - BrandCell.verticalMargin)
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout Methods
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        cellSize(for: collectionView)
    }
}
