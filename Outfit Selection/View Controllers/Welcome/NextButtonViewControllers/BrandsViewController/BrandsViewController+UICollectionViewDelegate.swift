//
//  BrandsViewController+UICollectionViewDelegate.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 27.11.2020.
//  Copyright © 2020 Denis Bystruev. All rights reserved.
//

import UIKit

// MARK: - UICollectionViewDelegate
extension BrandsViewController: UICollectionViewDelegate {
    /// Perform an action when a user taps an item in the brands collection view
    /// - Parameters:
    ///   - collectionView: the brands collection view
    ///   - indexPath: item index path the user has tapped on
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        searchBar?.endEditing(true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            guard let brandCell = collectionView.cellForItem(at: indexPath) as? BrandCollectionViewCell else {
                debug("WARNING: Can't cast cell at \(indexPath) to \(BrandCollectionViewCell.self)")
                return
            }
            
            let brand = self.brands[indexPath.row]
            
            // Toggle alpha between 0.25 and 1
            brand.toggleSelection()
            brandCell.configureBackground(isSelected: brand.isSelected)
            
            // Configure the buttons
            self.configureAllButton()
            self.configureNextButton()
        }
    }
}
