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
        
        debug(Collection.last?.itemCount)
        
        // Get the most current collection
        guard let lastCollection = Collection.last else {
            debug("WARNING: collections are empty")
            return
        }
        
        debug(lastCollection.itemCount)
        
        self.waitLastConnection(
            lastCollection: lastCollection,
            collectionItem: collectionItem,
            wishlistCell: wishlistCell) { count in
                
                // Update collection name label
                let count = count
                debug(count)
                let textCount = count == 0 ? "" : " \(count) "
                
                // Configre chooseItemsButton
                let textLabel = count == 0 ? "Choose items"~ : "Add"~ + textCount + "items"~
                let isEnabled = count != 0
                chooseItemsButton.backgroundColor = isEnabled
                ? Globals.Color.Button.enabled
                : Globals.Color.Button.disabled
                chooseItemsButton.isEnabled = isEnabled
                
                // Set textLabel for chooseItemsButton
                chooseItemsButton.setTitle(textLabel, for: .normal)
                
                // Update state of top right corner button
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    wishlistCell.selectButton.isSelected = isEnabled
                }
            }
    }
    
    /// Call before configure a button
    /// - Parameters:
    ///   - lastCollection: feed item collection type (kind)
    ///   - collectionItem: the collection items tapped occasion
    ///   - wishlistCell: wishlistCell
    private func waitLastConnection(
        lastCollection: Collection,
        collectionItem: CollectionItemCatalog,
        wishlistCell: WishlistBaseCell, completion: (Int) -> Void )
    {
        if lastCollection.contains(collectionItem) {
            lastCollection.remove(collectionItem)
            wishlistCell.isSelected = false
            wishListItemsCount -= collectionItem.itemIDs.count
            completion(wishListItemsCount)
            
        } else {
            lastCollection.append(collectionItem)
            wishlistCell.isSelected = true
            wishListItemsCount += collectionItem.itemIDs.count
            completion(wishListItemsCount)
        }
    }
}
