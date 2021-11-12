//
//  PinnableScrollViews+Extension.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 07/09/2019.
//  Copyright © 2019–2020 Denis Bystruev. All rights reserved.
//

import UIKit

typealias PinnableScrollViews = [PinnableScrollView]

extension PinnableScrollViews {
    // MARK: - Computed Properties
    /// True if all scroll views are pinned, false otherwise
    var allPinned: Bool {
        reduce(true) { $0 && $1.isPinned }
    }
    
    /// True if any scroll view is decelerating
    var isDecelerating: Bool {
        reduce(false) { $0 || $1.isDecelerating }
    }
    
    /// True if any scroll view is dragging
    var isDragging: Bool {
        reduce(false) { $0 || $1.isDragging }
    }
    
    /// True if any scroll view is scrolling (decelerating or dragging)
    var isScrolling: Bool { isDecelerating || isDragging }
    
    /// True if any scroll view is tracking
    var isTracking: Bool {
        reduce(false) { $0 || $1.isTracking }
    }
    
    /// Time when offset of any of scroll views was last changed
    var offsetChanged: Date? {
        compactMap { $0.offsetChanged }.max()
    }
    
    // MARK: - Methods
    /// Clear all scroll views
    func clear() {
        forEach { $0.clear() }
    }
    
    /// Clear borders of all scroll views
    func clearBorders() {
        forEach { $0.clearBorder() }
    }
    
    /// Pin all scroll views
    func pin() {
        forEach { $0.pin() }
    }
    
    /// Remove the images not matching cornered subcategory IDs from scroll views
    /// - Parameters:
    ///   - corneredSubcategoryIDs: cornered subcategory IDs from occasions
    func removeImages(notMatching corneredSubcategoryIDs: [[Int]]) {
        // Loop all scroll views and remove the items
        for (subcategoryIDs, scrollView) in zip(corneredSubcategoryIDs, self) {
            scrollView.removeImageViews(notMatching: subcategoryIDs)
        }
    }
    
    /// Restore borders of all scroll views
    func restoreBorders() {
        forEach { $0.restoreBorder() }
    }
    
    /// Set scroll views' unpinned alpha to given value
    /// - Parameter alpha: the value to set unpinned scroll views' alpha to, usually 0.75 or 1
    func setUnpinned(alpha: CGFloat) {
        forEach { $0.unpinnedAlpha = alpha }
    }
    
    /// Scroll its views to the given tags
    /// - Parameters:
    ///   - IDs: the ids to scroll the scroll views to
    ///   - ordered: if true assume IDs are given in the same order as scroll views
    ///   - completion: the block of code to be executed when scrolling ends
    func scrollToElements(with IDs: [String], ordered: Bool, completion: ((Bool) -> Void)? = nil) {
        // Scroll group to control completion of all scrolls
        let scrollGroup = DispatchGroup()
        
        // Flag to check if all scrolls are completed
        var isCompleted = true
        
        if ordered {
            // Scroll each scroll view to the matching item ID
            for (id, scrollView) in zip(IDs, self) {
                scrollGroup.enter()
                scrollView.scrollToElementIfPresent(with: id) { completed in
                    isCompleted = completed && isCompleted
                    scrollGroup.leave()
                }
            }
        } else {
            // Check each scroll view for the presense of item ID and scroll to it
            for scrollView in self {
                for id in IDs {
                    scrollGroup.enter()
                    scrollView.scrollToElementIfPresent(with: id) { completed in
                        isCompleted = completed && isCompleted
                        scrollGroup.leave()
                    }
                }
            }
        }
        
        // Call completion only when all scrolls are completed
        scrollGroup.notify(queue: .main) {
            completion?(isCompleted)
        }
    }
    
    /// Set visibility of items with subcategories given in the same order as scroll views
    /// - Parameters:
    ///   - corneredSubcategories: the cornered item subcategories to set visibility of
    ///   - visible: if true show matching items and hide non-matching items, if false — the other way around
    func setElements(in corneredSubcategoryIDs: [[Int]], visible: Bool) {
        // Set visibility of items in the scroll views
        for (scrollView, subcategoryIDs) in zip(self, corneredSubcategoryIDs) {
            scrollView.setElements(with: subcategoryIDs, visible: visible)
        }
    }
    
    /// Unpin all scroll views
    func unpin() {
        forEach { $0.unpin() }
    }
}
