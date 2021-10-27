//
//  WishlistViewController+UIViewController.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 07.09.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import UIKit

// MARK: - UIViewController Inherited Methods
extension WishlistViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        
        case ItemViewController.segueIdentifier:
            // Make sure destination is item view controller
            guard let destination = segue.destination as? ItemViewController else {
                debug("WARNING: \(segue.destination) is not \(ItemViewController.self)")
                return
            }
            
            // If we were sent by feed item use its item and image information to configure destination
            if let feedItem = sender as? FeedItem {
                destination.configure(with: feedItem.item, image: feedItem.itemImageView.image)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure navigation controller's bar font
        navigationController?.configureFont()
        
        // Register cells, set data source and delegate for collections table view
        feedController.setup(collectionsCollectionView, withBrandsOnTop: false)
        feedController.parentNavigationController = navigationController
        
        // Register feed item collection cell with wishlist collection view
        FeedItemCollectionCell.register(with: wishlistCollectionView)
        
        // Fill feed controller with collections and items
        Collection.all.forEach { collection in
            feedController.addSection(items: collection.items, to: .collections(collection.name))
        }
        
        // Set data source and delegate for wish list collection view
        wishlistCollectionView.dataSource = self
        wishlistCollectionView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        selectSuggestedTab()
        updateUI()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        updateUI(isHorizontal: size.height < size.width)
    }
}
