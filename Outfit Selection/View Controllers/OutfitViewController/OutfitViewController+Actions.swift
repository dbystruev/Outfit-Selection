//
//  ViewController+Actions.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 19/06/2019.
//  Copyright © 2019–2020 Denis Bystruev. All rights reserved.
//

import UIKit

// MARK: - Actions
extension OutfitViewController {
    /// Called when hanger bar button in navigation brat is tapped
    /// - Parameter sender: the hanger bar button which was tapped
    @IBAction func hangerBarButtonItemTapped(_ sender: Any) {
        showHangerBubble = false
        showHangerButtons.toggle()
    }
    
    /// Called when the user taps hanger bubble
    @objc func hangerBubbleTapped() {
        showHangerBubble = false
        showRefreshBubble = true
        showBubbles()
    }
    
    /// Called when one of individual hanger buttons in a scroll view is tapped
    /// - Parameter sender: the hanger button which was tapped
    @IBAction func hangerButtonTapped(_ sender: UIButton) {
        // Find the index of scroll view whose hanger button is tapped
        guard let selectedIndex = hangerButtons.firstIndex(of: sender) else { return }
        
        // Toggle (pin/unpin) selected scroll view
        scrollViews[selectedIndex].toggle()
        
        // Disable refresh button if all scroll views are pinned
        refreshButton.isEnabled = !scrollViews.allPinned
        
        // Update hanger buttons opacity
        configureHangerButtons()
    }
    
    /// Called when the user taps refresh bubble
    @objc func refreshBubbleTapped() {
        showRefreshBubble = false
    }
    
    @IBAction func refreshButtonTapped(_ sender: Any) {
        showRefreshBubble = false
        scrollToRandomItems()
    }
    
    @IBAction func likeButtonTapped(_ sender: UIButton) {
        // Set most recent like/dislike to outfits
        Wishlist.tabSuggested = .outfit
        
        // Dislike if we already liked it, or like if we didn't
        if Wishlist.contains(items) == true {
            sender.isSelected = false
            Wishlist.remove(items)
        } else {
            let controller = storyboard?.instantiateViewController(withIdentifier: "occasionsViewController")
            guard let occasionsViewController = controller as? OccasionsViewController else { return }
            occasionsViewController.items = items
            present(occasionsViewController, animated: true)
        }
    }
    
    @IBAction func shareButtonTapped(_ sender: UIBarButtonItem) {
        // Get the images and check that all of them are not nil
        let imageViews = scrollViews.compactMap { $0.getImageView() }
        let images = imageViews.compactMap { $0.image }
        let items = imageViews.compactMap { Item.all[safe: $0.tag] }
        guard images.count == scrollViews.count && images.count == items.count else { return }
        
        // Create a view for screenshot
        shareView = ShareView.instanceFromNib()
        shareView?.configureContent(with: images, items: items)
        
        // Segue to share view controller
        performSegue(withIdentifier: "shareViewControllerSegue", sender: self)
    }
}
