//
//  WishlistViewController+Navigation.swift
//  Outfit Selection
//
//  Created by Evgeniy Goncharov on 30.05.2022.
//  Copyright © 2022 Denis Bystruev. All rights reserved.
//

import UIKit

extension WishlistViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case FeedItemViewController.segueIdentifier:
            // Make sure destination is feedItem view controller
            guard let destination = segue.destination as? FeedItemViewController else {
                debug("WARNING: \(segue.destination) is not \(FeedItemViewController.self)")
                return
            }
            
            // Exctract data from sender
            let data = sender as? [String: Items]
            // Configure ItemViewController with exctracted data
            destination.configure(.hello, with: data?.first?.value, named: data?.first?.key, edit: false, indexSection: 0)
            
        case ItemViewController.segueIdentifier:
            // Make sure destination is item view controller
            guard let destination = segue.destination as? ItemViewController else {
                debug("WARNING: \(segue.destination) is not \(ItemViewController.self)")
                return
            }
            
            // If we were sent by feed item use its item and image information to configure destination
            if let feedItem = sender as? FeedItem {
                destination.configure(with: feedItem.item, image: feedItem.itemImageView.image)
                destination.isEditingCollection = true
                destination.parentNavigationController = feedController.parentNavigationController
                return
            }
            
            // if sender as Item
            if let item = sender as? Item {
                destination.configure(with: item, image: imageView?.image)
                debug("INFO: prepare for segue with item:", item)
                return
            }
            
            // Check if any cell is selected
            guard let selectedIndexPath = wishlistCollectionView.indexPathsForSelectedItems?.first else {
                debug("WARNING: No index path is selected in", wishlistCollectionView)
                return
            }
            
            // Check that selected cell is wishlist item cell
            guard let itemCell = wishlistCollectionView.cellForItem(at: selectedIndexPath) as? WishlistItemCell else {
                debug("WARNING: Can't cast cell at \(selectedIndexPath) to \(WishlistItemCell.self)")
                return
            }
            
            // Configure item view controller with given item and image
            destination.configure(with: wishlist[selectedIndexPath.row].item, image: itemCell.pictureImageView.image)
            debug(wishlist[selectedIndexPath.row].item)
            
        case CollectionNameViewController.segueIdentifier:
            guard let destination = segue.destination as? CollectionNameViewController else {
                debug("WARNING: \(segue.destination) is not \(CollectionNameViewController.self)")
                return
            }
            
            // Use wishlist items or outfits to create new collection items
            destination.wishlistViewController = self
            
        case CollectionSelectViewController.segueIdentifier:
            guard let destination = segue.destination as? CollectionSelectViewController else {
                debug("WARNING: \(segue.destination) is not \(CollectionSelectViewController.self)")
                return
            }
            
            guard let sender = sender as? CollectionNameViewController else {
                debug("WARNING: \(String(describing: sender)) is not \(CollectionNameViewController.self)")
                return
            }
            
            guard let collectionName = sender.collectionName, !collectionName.isEmpty else {
                debug("WARNING: \(sender).collectionName is nil or empty")
                return
            }
            
            // Use wishlist items or outfits to create new collection items
            destination.collectionName = collectionName
            destination.wishlistViewController = self
            
            // Create new collection
            Collection.append(Collection(Gender.current, collectionName))
            
        default:
            debug("WARNING: Unknown segue identifier", segue.identifier)
        }
    }
}
