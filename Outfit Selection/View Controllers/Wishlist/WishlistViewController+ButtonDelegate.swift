//
//  WishlistViewController+ButtonDelegate.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 07.09.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import Foundation

extension WishlistViewController: ButtonDelegate {
    /// Called when:
    ///     - item or outfit is selected in new collection creation, or
    ///     - feed item is tapped, or
    ///     - wishlist item / outfit cell is tapped
    /// - Parameter sender: item or outfit selected
    func buttonTapped(_ sender: Any) {
        // Check if feed item was tapped
        if let feedItem = sender as? FeedItem {
            debug()
            performSegue(withIdentifier: ItemViewController.segueIdentifier, sender: feedItem)
            return
        }
        
        // Check that indeed we were called from one of wishlist cells
        guard let wishlistCell = sender as? WishlistBaseCell else {
            debug("WARNING: \(sender) is not a WishlistBaseCell")
            return
        }
        
        // Try to get collection item from sender
        guard let collectionItem: CollectionItemCatalog = {
            // Check if sender is an item
            if let item = wishlistCell.element as? Item  {
                // Try to get collection item from an item
                return CollectionItemCatalog(item)
                // Or if sender is a wishlist
            } else if let wishlist = wishlistCell.element as? WishlistItemCatalog {
                // Try to get collection item from the list of wishlist items
                
                return CollectionItemCatalog(wishlist.items.values.map { $0 })
            } else { return nil }
        }() else {
            debug("WARNING: \(wishlistCell) is not a wishlist item or outfit cell")
            return
        }
        
        // If button is nil we haven't started to create a collection
        guard let chooseItemsButton = chooseItemsButton else {
            createCollectionButtonTapped(createCollectionButton)
            return
        }
        
        // Get the most current collection
        guard let lastCollection = Collection.last else {
            debug("WARNING: collections are empty")
            return
        }
        
        // Update last collection by removing / adding collection item tapped
        let itemCount = update(lastCollection, with: collectionItem, wishlistCell: wishlistCell)
        
        // Configure chooseItemsButton
        let isEnabled = itemCount != 0
        chooseItemsButton.backgroundColor = isEnabled
        ? Globals.Color.Button.enabled
        : Globals.Color.Button.disabled
        chooseItemsButton.isEnabled = isEnabled
        
        // Set textLabel for chooseItemsButton
        let textLabel = String.localizedStringWithFormat("Add %d items(s)"~, itemCount)
        chooseItemsButton.setTitle(textLabel, for: .normal)
        
        // Make sure current cell is selected / deselected
        guard let collectionView = CollectionSelectViewController.collectionView else {
            debug("WARNING: \(CollectionSelectViewController.self) collection view is nil")
            return
        }
        
        // Find out index path for wishlist cell
        guard let indexPath = collectionView.indexPath(for: wishlistCell) else {
            debug("WARNING: index path for wishlist cell is nil")
            return
        }
        
        // Make sure wishlist cell selection status corresponds to item selection in collection view
        if wishlistCell.isSelected {
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
        } else {
            collectionView.deselectItem(at: indexPath, animated: false)
        }
    }
    
    /// Update last collection and add/remove collection item before configuring a button
    /// - Parameters:
    ///   - lastCollection: collection of collection items to update
    ///   - collectionItem: collection item which was tapped
    ///   - wishlistCell: wishlist cell which should be selected / unselected
    /// - Returns: the number of items in wishlist
    private func update(
        _ lastCollection: Collection,
        with collectionItem: CollectionItemCatalog,
        wishlistCell: WishlistBaseCell
    ) -> Int {
        if lastCollection.contains(collectionItem) {
            lastCollection.remove(collectionItem)
            wishlistCell.isSelected = false
            wishListItemsCount -= collectionItem.itemIDs.count
            return wishListItemsCount
            
        } else {
            lastCollection.append(collectionItem)
            wishlistCell.isSelected = true
            wishListItemsCount += collectionItem.itemIDs.count
            return wishListItemsCount
        }
    }
}
