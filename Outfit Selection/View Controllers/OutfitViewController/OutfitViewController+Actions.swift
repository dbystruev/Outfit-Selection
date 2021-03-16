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
    @IBAction func hangerBarButtonItemTapped(_ sender: UIBarButtonItem) {
        let shouldUnpin = scrollViews.allPinned
        likeButtons.forEach { $0.isHidden = shouldUnpin }
        if shouldUnpin {
            scrollViews.unpin()
        } else {
            scrollViews.pin()
        }
        refreshButton.isEnabled = shouldUnpin
    }
    
    @IBAction func hangerButtonTapped(_ sender: UIButton) {
        guard let selectedIndex = likeButtons.firstIndex(of: sender) else { return }
        
        let scrollView = scrollViews[selectedIndex]
        scrollView.toggle()
        
        likeButtons[selectedIndex].isHidden = !scrollView.isPinned
        refreshButton.isEnabled = !scrollViews.allPinned
    }
    
    @IBAction func refreshButtonTapped(_ sender: UIButton) {
        scrollToRandomItems()
    }
    
    @IBAction func likeButtonTapped(_ sender: UIButton) {
        // Set most recent like/dislike to outfit, not item
        Wishlist.itemsTabSuggested = false
        
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
        let images = scrollViews.compactMap { $0.getImageView()?.image }
        guard images.count == scrollViews.count else { return }
        
        // Create a view for screenshot
        let shareView = ShareView.instanceFromNib()
        shareView.configure(with: images)
        
        // Share the image
        let activityController = UIActivityViewController(activityItems: [shareView.asImage], applicationActivities: nil)
        activityController.popoverPresentationController?.sourceView = sender.customView
        present(activityController, animated: true)
    }
}
