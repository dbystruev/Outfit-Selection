//
//  WishlistViewController+ButtonDelegate.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 07.09.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

extension WishlistViewController: ButtonDelegate {
    /// Called when:
    ///     - item or outfit is selected in new collection creation, or
    ///     - feed item is tapped, or
    ///     - wishlist item / outfit cell is tapped
    /// - Parameter sender: item or outfit selected
    func buttonTapped(_ sender: Any) {
        // Check if feed item was tapped
        if let feedItem = sender as? FeedItem {
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
            if let item = wishlistCell.element as? Item {
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
        
        // If collection name label is nil we haven't started to create a collection
        guard let collectionNameLabel = collectionNameLabel else {
            createCollectionButtonTapped(createCollectionButton)
            return
        }
        
        // Get the most current collection
        guard let lastCollection = Collection.last else {
            debug("WARNING: collections are empty")
            return
        }
        
        // Depending on whether collection item is already present, add or remove it
        if lastCollection.contains(collectionItem) {
            lastCollection.remove(collectionItem)
            wishlistCell.isSelected = false
        } else {
            lastCollection.append(collectionItem)
            wishlistCell.isSelected = true
        }
        
        // Update collection name label
        let count = lastCollection.itemCount
        let textCount = count == 0 ? "None" : "\(count)"
        collectionNameLabel.text = "\(textCount) selected for \(lastCollection.name)"
    }
}
