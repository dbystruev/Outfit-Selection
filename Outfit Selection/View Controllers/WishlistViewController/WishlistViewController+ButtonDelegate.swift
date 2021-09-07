//
//  WishlistViewController+ButtonDelegate.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 07.09.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

extension WishlistViewController: ButtonDelegate {
    /// Called when item or outfit is selected in new collection creation
    /// - Parameter sender: item or outfit selected
    func buttonTapped(_ sender: Any) {
        // Get the most current collection
        guard let lastCollection = collections.last else {
            debug("WARNING: collections is empty")
            return
        }
        
        // Try to get collection item from sender
        guard let collectionItem: CollectionItem = {
            // Check if sender is an item
            if let item = sender as? Item {
                // Try to get collection item from an item
                return CollectionItem(item)
            // Or if sender is a wishlist
            } else if let wishlist = sender as? Wishlist {
                // Try to get collection item from the list of wishlist items
                return CollectionItem(wishlist.items)
            } else { return nil }
        }() else {
            debug("WARNING: \(sender) is not an item or a wishlist")
            return
        }
        
        // Depending on whether collection item is already present, add or remove it
        if lastCollection.contains(collectionItem) {
            lastCollection.remove(collectionItem)
        } else {
            lastCollection.append(collectionItem)
        }
        
        // Update collection name label
        let count = lastCollection.count
        let textCount = count == 0 ? "None" : "\(count)"
        collectionNameLabel?.text = "\(textCount) selected for \(lastCollection.name)"
    }
}
