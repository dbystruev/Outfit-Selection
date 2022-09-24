//
//  ViewController+UIScrollViewDelegate.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 19/06/2019.
//  Copyright © 2019–2020 Denis Bystruev. All rights reserved.
//

import UIKit

// MARK: - UIScrollViewDelegate
extension OutfitViewController: UIScrollViewDelegate {
    // MARK: - Static Constants
    /// Track when scroll views need to be updated
    private static var scrollGroup = DispatchGroup()
    
    /// Flag showing if scroll group notification was set
    private static var scrollGroupNotificationSet = false
    
    // MARK: - UIScrollViewDelegate Methods
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if decelerate { return }
        guard let pinnableScrollView = scrollView as? PinnableScrollView else { return }
        pinnableScrollView.scrollToCurrent()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard let pinnableScrollView = scrollView as? PinnableScrollView else { return }
        pinnableScrollView.scrollToCurrent()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Don't update UI if any scroll view is still scrolling
        guard !self.scrollViews.isUserScrolling else { return }
        
        // Delay for 0.1 s to let other scroll views to finish scrolling
        OutfitViewController.scrollGroup.enter()
        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 0.1) {
            OutfitViewController.scrollGroup.leave()
        }
        
        // Setup scroll group notification
        if !OutfitViewController.scrollGroupNotificationSet {
            OutfitViewController.scrollGroupNotificationSet = true
            OutfitViewController.scrollGroup.notify(queue: .main) {
                OutfitViewController.scrollGroupNotificationSet = false
                
                // Updates like button, total price, and subcategory labels
                self.updateUI()
            }
        }
    }
}
