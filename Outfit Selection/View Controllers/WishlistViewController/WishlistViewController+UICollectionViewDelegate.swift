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
        if itemsTabSelected {
            performSegue(withIdentifier: ItemViewController.segueIdentifier, sender: self)
        } else {
            // Get the navigation controller for the outfit view controller
            guard let navigationController = tabBarController?.viewControllers?.first as? UINavigationController else { return }
            
            // Find outfit view controller in navigation stack
            guard let outfitViewController = navigationController.findViewController(ofType: OutfitViewController.self) else { return }
            
            // Quickly navigate back from item view controller in case we are there
            if (navigationController.viewControllers.last as? ItemViewController) != nil {
                navigationController.popViewController(animated: false)
            }
            
            // Switch to the first (outfit view controller) tab
            tabBarController?.selectedIndex = 0
            
            // Scroll to the items in the current outfit
            outfitViewController.scrollToItems = wishlist[indexPath.row].items
        }
    }
}
