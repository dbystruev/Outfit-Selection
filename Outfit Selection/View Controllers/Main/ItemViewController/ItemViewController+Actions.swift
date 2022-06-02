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
    @objc func backButtonTapped() {
        
        // Restore saved items
        searchItems = searchItemsSave
        
        guard let searchItems = searchItems, !searchItems.isEmpty else {
            // Hide searchBar
            self.tableStackView.isHidden = true
            return
        }
        
        // Set seved text into search bar
        searchBar.text = searchText
        
        // Show tableView
        tableStackView.isHidden = false
        
        // Show back bar button
        backBarButtonItem.isEnabled = false
    }
    
    /// Call when leftBarButtonItem tapped
    @objc func cancelButtonTapped() {
        // Show tableView
        tableStackView.isHidden = true
        
        // Hide back bar button
        backBarButtonItem.isEnabled = false
        
        // Set empty text into search bar
        searchBar.text = ""
        
        // Restore saved item
        configure(with: firstItem, image: nil)
        
        // Hide backButton
        navigationItem.hidesBackButton = true
        isEditing.toggle()
    }
    
    /// Call when delete button  tapped
    private func deleteButtonTapped() {
        
        // Set isEditing to false
        setEditing(false, animated: false)
        
        // Find FeedItemViewController into hierarchy UINavigationController
        guard let feedItemViewController = parentNavigationController?.findViewController(ofType: FeedItemViewController.self) else {
            debug("WARNING: Can't find \(FeedItemViewController.self)")
            return
        }
        
        // Make shure that item is not nil
        guard let item = item else {
            debug("ERROR: Current item is nil")
            return
        }
        
        // Remove item from items into feed item view controller
        feedItemViewController.items.removeAll(where: { $0 == item })
        feedItemViewController.itemCollectionView.reloadData()
        
        // Find wishlist view controller into navigation controller
        guard let wishlistViewController = feedItemViewController.navigationController?.findViewController(ofType: WishlistViewController.self) else {
            debug("ERROR:", WishlistViewController.className, "not found in this navigation controller")
            return
        }
        
        // Extract index section
        let indexSection = feedItemViewController.indexSection
        let wishlistItems = wishlistViewController.feedController.items
        
        // Get pickType from items
        let pickType = wishlistItems[indexSection].key
        
        // Get items from items and add new item
        var items = wishlistItems[indexSection].value
        
        // Remove item from items
        items.removeAll(where: { $0 == item })
        
        // Remove collection from collections items
        wishlistViewController.feedController.items.removeValue(forKey: pickType)
        
        // Set new items into items from wishlist view controller
        wishlistViewController.feedController.items = wishlistItems.merging([pickType : items]) { $1 }
        
        // Delete item from Collection
        Collection.remove(item, index: indexSection)
        
        // Return to FeedItemViewController
        navigationController?.popToViewController(feedItemViewController, animated: true)
    }
    
    /// Call when rightBarButtonItem tapped
    @objc func editButtonItemTapped() {
        setEditing(!isEditing, animated: true)
        if !isEditing {
            orderButtonTapped(navigationItem)
        }
    }
    /// Call when UIimageView was tapped
    @objc func imageTapped(sender: UITapGestureRecognizer) {
        performSegue(withIdentifier: ImageViewController.segueIdentifier, sender: item)
    }
    
    /// Show alert with information to delete current item from collection
    @objc func showAlert() {
        let alert = Alert.configured(
            "Delete this item"~,
            message: "Are you sure you want to delete this item?"~,
            actionTitles: ["Cancel"~, "Yes"~],
            styles: [.cancel, .destructive],
            handlers: [{ _ in
            },{ _ in
                self.deleteButtonTapped()
            }])
        present(alert, animated: true)
    }
    
    // MARK: - Actions
    @IBAction func addToCollectionButton(_ sender: UIButton) {
        debug(item, sender)
    }
    
    @IBAction func addToWishlistButtonTapped(_ sender: WishlistButton) {
        guard let item = item else { return }
        sender.addToWishlistButtonTapped(for: item)
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        backButtonTapped()
    }
    
    @IBAction func dislikeButtonTapped(_ sender: WishlistButton) {
        guard let item = item else { return }
        present(Alert.dislike(item, handler: { _ in
            sender.dislikeButtonTapped(for: item)
            self.navigationController?.popViewController(animated: true)
        }), animated: true)
    }
    
    @IBAction func orderButtonTapped(_ sender: Any) {
        if isEditing || ((sender as? UINavigationItem) != nil)  {
            //debug(isEditingCollection, parentNavigationController != nil)
            if isEditingCollection {
                
                // Set isEditing to false
                setEditing(false, animated: false)
                
                // Find FeedItemViewController into hierarchy UINavigationController
                guard let feedItemViewController = parentNavigationController?.findViewController(ofType: FeedItemViewController.self) else {
                    debug("WARNING: Can't find \(FeedItemViewController.self)")
                    return
                }
                
                // Make shure that item is not nil
                guard let item = item else {
                    debug("ERROR: Current item is nil")
                    return
                }
                
                // Make shure that first item is not nil
                guard let firstItem = firstItem else {
                    debug("ERROR: First item item is nil")
                    return
                }
                
                // Replace old item from items to new item
                feedItemViewController.items.replaceElement(firstItem, withElement: item)
                feedItemViewController.itemCollectionView.reloadData()
                
                // Find wishlist view controller into navigation controller
                guard let wishlistViewController = feedItemViewController.navigationController?.findViewController(ofType: WishlistViewController.self) else {
                    debug("ERROR:", WishlistViewController.className, "not found in this navigation controller")
                    return
                }
                
                // Extract index section
                let indexSection = feedItemViewController.indexSection
                let wishlistItems = wishlistViewController.feedController.items
                
                // Get pickType from items
                let pickType = wishlistItems[indexSection].key
                
                // Get items from items and add new item
                var items = wishlistItems[indexSection].value
                
                // Replace old item from items to new item
                items.replaceElement(firstItem, withElement: item)
                
                // Remove collection from collections items
                wishlistViewController.feedController.items.removeValue(forKey: pickType)
                
                // Set new items into items from wishlist view controller
                wishlistViewController.feedController.items = wishlistItems.merging([pickType : items]) { $1 }
                
                // Update item to Collection
                Collection.update(item: firstItem, newItem: item, index: indexSection)
                
                // Return to FeedItemViewController
                navigationController?.popToViewController(feedItemViewController, animated: true)
                
            } else {
                
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
            }
            
        } else if isAddEnabled && parentNavigationController != nil {
            
            // Find FeedItemViewController into hierarchy UINavigationController
            guard let feedItemViewController = parentNavigationController?.findViewController(ofType: FeedItemViewController.self) else {
                debug("WARNING: Can't find \(FeedItemViewController.self)")
                return
            }
            
            // Make shure the item is not nil
            guard let item = item else { return }
            
            // Append new item into items from FeedItemViewController
            feedItemViewController.items.append(item)
            feedItemViewController.itemCollectionView.reloadData()
            
            // Extract index section
            let indexSection = feedItemViewController.indexSection
            
            // Find wishlist view controller into navigation controller
            guard let wishlistViewController = feedItemViewController.navigationController?.findViewController(ofType: WishlistViewController.self) else {
                debug("ERROR:", WishlistViewController.className, "not found in this navigation controller")
                return
            }
            
            // Get pickType from items
            let pickType = wishlistViewController.feedController.items[indexSection].key
            
            // Get items from items and add new item
            var items = wishlistViewController.feedController.items[indexSection].value
            items.append(item)
            
            // Remove collection from collections items
            wishlistViewController.feedController.items.removeValue(forKey: pickType)
            wishlistViewController.feedController.items = wishlistViewController.feedController.items.merging([pickType : items]) { $1 }
            
            // Add new item into Collection
            Collection.append(item, index: indexSection)
            
            dismiss(animated: true)
            
        } else {
            guard let url = item?.url else { return }
            self.url = url
            performSegue(withIdentifier: "intermediaryViewControllerSegue", sender: item)
        }
    }
    
    @IBAction func shareButtonTapped(_ sender: Any) {
        
        // Make sure item is not nil
        guard let item = item else { return }
        
        // Identificator for universal share link
        let id: String = "eq."
        // Get current item ID
        let itemID: String = item.id
        
        // Parts of the universal link
        let scheme = Global.UniversalLinks.scheme.https
        let domain = Global.UniversalLinks.domain.getoutfit
        let patch = Global.UniversalLinks.path.items
        
        // Build share link
        let itemURLShare = URL(string: scheme + domain + patch + id + itemID)
        
        // Share item url
        let activityController = UIActivityViewController(activityItems: [itemURLShare as Any], applicationActivities: nil)
        activityController.popoverPresentationController?.sourceView = (sender as AnyObject).customView
        present(activityController, animated: true)
    }
}
