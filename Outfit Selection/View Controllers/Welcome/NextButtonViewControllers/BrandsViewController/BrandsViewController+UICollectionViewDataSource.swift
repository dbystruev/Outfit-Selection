//
//  BrandsViewController+UICollectionViewDataSource.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 27.11.2020.
//  Copyright © 2020 Denis Bystruev. All rights reserved.
//

import UIKit

extension BrandsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        isEditing || !UserDefaults.hasAnswerQuestions ? brands.count : Brands.selected.count
    }
    
    // MARK: - UICollectionViewDataSource Methods
    /// Get cell for the given index path in brands collection view
    /// - Parameters:
    ///   - collectionView: brands collection view
    ///   - indexPath: index path to give the cell for
    /// - Returns: the cell for the given index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BrandCollectionViewCell.reuseId, for: indexPath)
        if cell as? BrandCollectionViewCell == nil {
            debug("WARNING: Can't cast \(BrandCollectionViewCell.reuseId) to \(BrandCollectionViewCell.self)")
        }
        
        // Get cell from BrandCollectionViewCell
        let brandCell = cell as? BrandCollectionViewCell ?? BrandCollectionViewCell(frame: cell.frame)
        // Get array with brands
        let brands = isEditing || !UserDefaults.hasAnswerQuestions ? brands : Brands.selected.sorted
        // Configure brands into BrandCollectionViewCell
        brandCell.configure(brand: brands[indexPath.row], cellSize: cellSize(for: collectionView))
        return brandCell
    }
}
