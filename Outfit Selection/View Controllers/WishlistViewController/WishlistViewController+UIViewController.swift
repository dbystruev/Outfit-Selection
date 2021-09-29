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
            guard let destination = segue.destination as? ItemViewController else { return }
            guard let selectedIndexPath = wishlistCollectionView.indexPathsForSelectedItems?.first else { return }
            guard let itemCell = wishlistCollectionView.cellForItem(at: selectedIndexPath) as? WishlistItemCell else { return }
            destination.image = itemCell.pictureImageView.image
            destination.item = wishlist[selectedIndexPath.row].item
            
        case CollectionNameViewController.segueIdentifier:
            guard let destination = segue.destination as? CollectionNameViewController else {
                debug("WARNING: \(segue.destination) is not CollectionsViewController")
                return
            }
            
            // Use wishlist items or outfits to create new collection items
            destination.wishlistViewController = self
            
        case CollectionSelectViewController.segueIdentifier:
            guard let destination = segue.destination as? CollectionSelectViewController else {
                debug("WARNING: \(segue.destination) is not CollectionSelectViewController")
                return
            }
            
            guard let sender = sender as? CollectionNameViewController else {
                debug("WARNING: \(String(describing: sender)) is not CollectionNameViewController")
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
            Collection.collections.append(Collection(Gender.current, collectionName))
            
        default:
            debug("WARNING: Unknown segue identifier", segue.identifier)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure navigation controller's bar font
        navigationController?.configureFont()
        
        // Register cells, set data source and delegate for collections table view
        feedController.setup(collectionsCollectionView)
        
        // Fill feed controller with collections and items
        Collection.collections.forEach { collection in
            feedController.add(items: collection.items, to: .occasions(collection.name))
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
