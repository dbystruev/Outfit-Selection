//
//  PinnableScrollView+removeImageViews.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 16.11.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import UIKit

extension PinnableScrollView {
    /// Remove image view with given item ID
    /// - Parameters:
    ///   - itemID: the item ID to delete
    func removeImageView(withItemID itemID: String) {
        // Find the index of element we need to delete
        guard let indexToDelete = itemIDs.firstIndex(of: itemID) else {
            debug("WARNING: Not found item ID \(itemID) in the scroll view")
            return
        }

        // Make sure we have an image view to delete
        guard let imageView = getImageView(withIndex: indexToDelete) else {
            debug("WARNING: Can't find image view with index \(indexToDelete)")
            return
        }
        
        // Don't delete the first image view — instead copy the second one to its place and remove it
        if indexToDelete < 1 {
            guard let secondImageView = getImageView(withIndex: indexToDelete + 1) else {
                debug("WARNING: Can't obtain image view with index \(indexToDelete + 1)")
                return
            }
            guard let item = secondImageView.item else {
                debug("WARNING: Can't obtain item from image view with index \(indexToDelete + 1)")
                return
            }
            imageView.image = secondImageView.image
            imageView.item = item
            imageView.tag = secondImageView.tag
            secondImageView.removeFromSuperview()
        } else {
            imageView.removeFromSuperview()
        }
    }
    
    /// Remove  images views not matching subcategory IDs from this scroll view
    /// - Parameters:
    ///   - subcategoryIDs: subcategory IDs from occasion
    func removeImageViews(notMatching subcategoryIDs: [Int]) {
        // Make a set of subcategory IDs to make comparisons easier
        let subcategoryIDSet = Set(subcategoryIDs)
        
        // Loop each image view from last to first
        for index in stride(from: count - 1, to: 0, by: -1) {
            guard let imageView = getImageView(withIndex: index) else {
                debug("WARNING: Can't get image view with index \(index)")
                continue
            }
            guard let item = imageView.item else {
                debug("WARNING: Can't get an item from image view \(imageView)")
                continue
            }
            
            // Remove image views which have no common subcategories with given set
            if subcategoryIDSet.intersection(item.subcategoryIDs).isEmpty {
                removeImageView(withItemID: item.id)
            }
        }
    }
}
