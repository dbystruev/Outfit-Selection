//
//  FeedCollectionViewController+UICollectionViewDelegate.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 29.09.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import UIKit

extension FeedCollectionViewController: UICollectionViewDelegate {
    /// Perform an action when a user taps an item in the brands collection view
    /// - Parameters:
    ///   - collectionView: the brands collection view
    ///   - indexPath: item index path the user has tapped on
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let brandCell = collectionView.cellForItem(at: indexPath) as? BrandCollectionViewCell else { return }
        let brandedImage = brandedImages[indexPath.row]
        
        // Toggle alpha between 0.25 and 1
        brandedImage.isSelected.toggle()
        brandCell.configureBackground(isSelected: brandedImage.isSelected)
        
        // Make feed item cells reload
        reloadDataOnBrandChange()
    }
}
