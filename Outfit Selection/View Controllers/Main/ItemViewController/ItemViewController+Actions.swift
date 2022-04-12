//
//  ItemViewController+Actions.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 16.03.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import UIKit

extension ItemViewController {
    // MARK: - Helper Methods
    /// Call when leftBarButtonItem tapped
    @objc func cancelButtonTap() {
        // Hide backButton
        navigationItem.hidesBackButton = true
        isEditing.toggle()
    }
    /// Call when rightBarButtonItem tapped
    @objc func editButtonItemTap() {
        setEditing(!isEditing, animated: true)
        if !isEditing {
            orderButtonTapped(navigationItem)
        }
    }
    
    // MARK: - Actions
    @IBAction func addToCollectionButton(_ sender: UIButton) {
        debug(item, sender)
    }
    
    @IBAction func addToWishlistButtonTapped(_ sender: WishlistButton) {
        guard let item = item else { return }
        sender.addToWishlistButtonTapped(for: item)
    }
    
    @IBAction func dislikeButtonTapped(_ sender: WishlistButton) {
        guard let item = item else { return }
        present(Alert.dislike(item, handler: { _ in
            sender.dislikeButtonTapped(for: item)
            self.navigationController?.popViewController(animated: true)
        }), animated: true)
    }
    
    @IBAction func orderButtonTapped(_ sender: Any) {
        if isEditing || ((sender as? UINavigationItem) != nil) {
            
            navigationItem.rightBarButtonItem?.isEnabled = false
            // Get OutfitViewController
            guard let outfitViewController = navigationController?.findViewController(ofType: OutfitViewController.self) else {
                debug("ERROR: Can't find outfitViewController")
                return
            }
            // Get is showing items from OutfitViewController
            var items = outfitViewController.visibleItems
            // Get index current item into occasion items array
            guard let index = items.firstIndex(where: {$0.id == firstItem?.id}) else {
                debug("ERROR: Can't find itemID into items", items)
                return
            }
            
            // Get current chosen item
            guard let item = item else {
                debug("ERROR: Can't find item into items")
                return
            }
            
            // Set a new item into ocassion array
            items[index] = item
            
            // Download all images and add to viewModels
            ItemManager.shared.loadImagesFromItems(items: items) {
                
                // Go to NavigationManager into outfit and show back button
                NavigationManager.navigate(to: .outfit(items: items, hideBackButton: true))
            }
            
        } else {
            guard let url = item?.url else { return }
            self.url = url
            performSegue(withIdentifier: "intermediaryViewControllerSegue", sender: sender)
        }
    }
    
    @IBAction func shareButtonTapped(_ sender: Any) {
        // Make sure item url is not nil
        guard let itemURL = item?.url else { return }
        
        // Share item url
        let activityController = UIActivityViewController(activityItems: [itemURL], applicationActivities: nil)
        activityController.popoverPresentationController?.sourceView = (sender as AnyObject).customView
        present(activityController, animated: true)
    }
}
