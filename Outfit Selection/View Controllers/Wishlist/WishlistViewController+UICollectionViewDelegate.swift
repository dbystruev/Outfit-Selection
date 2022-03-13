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
        switch collectionView {
            // We are on collection selection screen
        case CollectionSelectViewController.collectionView:
            // Get the cell which was tapped
            guard let wishlistCell = collectionView.cellForItem(at: indexPath) as? WishlistBaseCell else {
                debug("WARNING: item at \(indexPath) is not a \(WishlistBaseCell.self)")
                return
            }
            
            // Emulate button tap in the top right corner
            wishlistCell.selectButtonTapped(wishlistCell.selectButton)
            
            // We are on wishlist screen
        case wishlistCollectionView:
            switch tabSelected {
                
            case .collection:
                debug("ERROR: not implemented for .collections")
                
            case .item:
                performSegue(withIdentifier: ItemViewController.segueIdentifier, sender: self)
                
            case .outfit:
                
                // Get items from wishlist
                let items = wishlist[indexPath.row].items.compactMap { $0.value }
                let ids = wishlist[indexPath.row].itemIDs
                
                // Sortered items value
                let sorteredItem = ids.compactMap { id in
                    items.first { $0.id == id }
                }
                
                // Download all images and add to viewModels
                ItemManager.shared.loadImagesFromItems(items: sorteredItem) {
                    
                    // Go to NavigationManager into outfit and show back button
                    NavigationManager.navigate(to: .outfit(items: sorteredItem, backButton: false))
                }
                
            case nil:
                debug("ERROR: selected tab should not be nil")
            }
        default:
            debug("WARNING: unknown collection view")
        }
    }
}
