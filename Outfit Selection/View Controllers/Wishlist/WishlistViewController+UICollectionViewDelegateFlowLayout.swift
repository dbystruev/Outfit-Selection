//
//  WishlistViewController+UICollectionViewDelegateFlowLayout.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 25.02.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import UIKit

extension WishlistViewController: UICollectionViewDelegateFlowLayout {
    // MARK: - Computed Properties
    /// The height of the cell in the wishlist collection view
    fileprivate var cellHeigth: CGFloat { round(3 * cellWidth / 2) }
    
    /// The size of the cell in the wishlist collection view
    var cellSize: CGSize { CGSize(width: cellWidth, height: cellHeigth) }
    
    /// The width of the cell in the wishlist collection view
    fileprivate var cellWidth: CGFloat {
        let rows = CGFloat(cellsPerRow)
        return floor((wishlistCollectionView.bounds.size.width - 28 * (rows - 1)) / rows)
    }
    
    // MARK: - Methods
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        cellSize
    }
}
