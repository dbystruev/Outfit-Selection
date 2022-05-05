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
        
        // Check status brand
        guard !lockBrands else { return }
        
        // Toggle alpha between 0.25 and 1
        brandedImage.toggleSelection()
        brandCell.configureBackground(isSelected: brandedImage.isSelected)
        
        guard brandedImages.filter({ $0.isSelected }).count > 0 else {
            // Set empty section
            sections = feedSectionEmpty
            
            // Reload data into UICollectionView
            self.feedCollectionView.reloadData()
            return
        }
        
        // Remove items with deselected brand
        if !brandedImage.isSelected {
            for feedKind in self.items {
                
                // Filtered items without deselected brand
                let filteredItems: Items = feedKind.value.filter { !$0.branded([brandedImage.name]) }
                
                // Set new items for FeedKind
                self.items[feedKind.key] = filteredItems
                
                // Get index with updated element
                let updatedSections = self.nonEmptySections.enumerated().compactMap { index, kind in
                    feedKind.key == kind ? index : nil
                }
                
                // Reload sections where was updated items
                feedCollectionView?.reloadSections(IndexSet(updatedSections))
                
                updateItems(sections: [feedKind.key])
            }
            
        } else {
            // Make feed item cells reload
            setSection()
        }
        
        // Reload data into UICollectionView
        self.feedCollectionView.reloadData()
    }
}
