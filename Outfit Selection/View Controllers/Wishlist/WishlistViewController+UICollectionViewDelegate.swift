//
//  WishlistViewController+UICollectionViewDelegate.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 27.02.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import UIKit

extension WishlistViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Don't select anything in case we are not on wishlist screen
        guard collectionView == wishlistCollectionView else { return }
        
        debug(wishlist[indexPath.row].itemIDs)
        
        switch tabSelected {
        
        case .collection:
            debug("ERROR: not implemented for .collections")
        
        case .item:
            performSegue(withIdentifier: ItemViewController.segueIdentifier, sender: self)
            
        case .outfit:
            // Get the navigation controller for the outfit view controller
            guard
                let navigationController = tabBarController?.viewControllers?.first as? UINavigationController
            else { return }
            
            // Find outfit view controller in navigation stack
            guard
                let outfitViewController = navigationController.findViewController(ofType: OutfitViewController.self)
            else { return }
            
            // Quickly navigate back from item view controller in case we are there
            if (navigationController.viewControllers.last as? ItemViewController) != nil {
                navigationController.popViewController(animated: false)
            }
            
            // Check if an occasion with the same name is selected
            let catalog = wishlist[indexPath.row]
            guard outfitViewController.occasionSelected?.title == catalog.name else {
                debug(
                    "WARNING: Trying to go from", outfitViewController.occasionSelected?.title,
                    "to", catalog.name
                )
                return
            }
            
            // Switch to the first (outfit view controller) tab
            tabBarController?.selectedIndex = 0
            
            // Scroll to the items in the current outfit
            outfitViewController.wishlistName = catalog.name
            outfitViewController.wishlistItems = catalog.items.values.map { $0 }
            
        case nil:
            debug("ERROR: selected tab should not be nil")
        }
    }
}
