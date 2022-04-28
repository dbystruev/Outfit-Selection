//
//  FeedCollectionViewController+UICollectionViewDelegate.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 29.09.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import UIKit

extension FeedCollectionViewController: UICollectionViewDelegate {
    /// Perform an action when the user taps a brand in the collection view
    /// - Parameters:
    ///   - collectionView: the brands collection view
    ///   - indexPath: item index path the user has tapped on
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let brandCell = collectionView.cellForItem(at: indexPath) as? BrandCollectionViewCell else { return }
        
        let brandedImage = Brands.prioritizeSelected[indexPath.row]
        
        // Toggle alpha between 0.25 and 1
        brandedImage.toggleSelection()
        brandCell.configureBackground(isSelected: brandedImage.isSelected)
      
        // Remove items with deselected brand
        if !brandedImage.isSelected {
            for (index ,feedKind) in self.items.enumerated() {
                let filteredItems: Items = feedKind.value.filter { $0.brand != brandedImage.name }
                self.items[feedKind.key] = filteredItems
                
                debug("\n", "INFO: Found ", feedKind.value.count - filteredItems.count, "of brand",
                      brandedImage.name, "into", sections[index].title, "\n",
                      "INFO: New items count for", sections[index].title, self.items[feedKind.key]?.count )
            }
        }

        // Make feed item cells reload
        setSection()
        
        // Reload data
        self.feedCollectionView.reloadData()
        
//        // Make sure like buttons are updated when we come back from see all screen
//        feedCollectionView.visibleCells.forEach {
//            ($0 as? FeedItemCollectionCell)?.configureLikeButton()
//        }
    }
}
