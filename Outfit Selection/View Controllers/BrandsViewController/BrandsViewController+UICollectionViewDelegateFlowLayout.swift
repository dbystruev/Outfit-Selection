//
//  BrandsViewController+UICollectionViewDelegateFlowLayout.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 16.02.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import UIKit

extension BrandsViewController: UICollectionViewDelegateFlowLayout {
    // MARK: - Computed Properties
    /// The height of the cell in the brands collection view
    fileprivate var cellHeight: CGFloat { cellWidth - 2 * (BrandCell.horizontalMargin - BrandCell.verticalMargin) }
    
    /// The size of the cell in the brands collection view
    var cellSize: CGSize { CGSize(width: cellWidth, height: cellHeight) }
    
    /// The width of the cell in the brands collection view
    fileprivate var cellWidth: CGFloat { floor(brandsCollectionView.bounds.size.width / CGFloat(BrandCell.cellsPerRow)) }
    
    // MARK: - Methods
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        cellSize
    }
}
