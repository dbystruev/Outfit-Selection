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
        return reduce(true) { $0 && $1.isPinned }
    }
    
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
    func scrollToElements(with IDs: [String], ordered: Bool) {
        if ordered {
            // Scroll each scroll view to the matching item ID
            for (id, scrollView) in zip(IDs, self) {
                scrollView.scrollToElementIfPresent(with: id)
            }
        } else {
            // Check each scroll view for the presense of item ID and scroll to it
            for scrollView in self {
                for id in IDs {
                    scrollView.scrollToElementIfPresent(with: id)
                }
            }
        }
    }
    
    /// Unping all scroll views
    func unpin() {
        forEach { $0.unpin() }
    }
}
