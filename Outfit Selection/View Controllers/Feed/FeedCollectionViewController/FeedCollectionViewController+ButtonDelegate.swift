//
//  FeedCollectionViewController+ButtonDelegate.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 29.09.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import UIKit

extension FeedCollectionViewController: ButtonDelegate {
    func buttonTapped(_ sender: Any) {
        // Check if `see all` button was tapped in the feed section header
        if let feedHeader = sender as? FeedSectionHeaderView {
            
            // Configure and push feed item view controller
            let kind = feedHeader.kind
            
            // Check if we came from wish list
            guard let wishlistNavigationController = parentNavigationController else {
                
                // All sections will need to be filtered by brands
                let brandManager = BrandManager.shared
                let brandNames = brandManager.selectedBrandNames
                
                // Categories should be limited for occasions
                let subcategoryIDs: [Int] = {
                    if case let .occasions(id) = kind {
                        return Occasions.byID[id]?.flatSubcategoryIDs.compactMap { $0 } ?? []
                    } else {
                        return []
                    }
                }()
                
                // If feed type is sale get items with old prices set
                let sale = kind == .sale
                
                // Make parameters for get
                let parametrs = NetworkManager.shared.parameters(
                    for: Gender.current,
                       in: [],
                       subcategoryIDs: subcategoryIDs,
                       limited: 1,
                       sale: sale,
                       filteredBy: brandNames
                )
                
                // Request head to get Content-Range from the API
                NetworkManager.shared.exactCount(with: parametrs, header: "Content-Range") { T in
                    debug("Content-Range:", T)
                    Globals.Feed.contentRange = T ?? 0
                }
                
                performSegue(withIdentifier: FeedItemViewController.segueIdentifier, sender: feedHeader)
                return
            }
            
            // Instantiate a view controller from feed storyboard
            let feedStoryboard = UIStoryboard(name: "Feed", bundle: nil)
            let identifier = String(describing: FeedItemViewController.self).decapitalizingFirstLetter
            let viewController = feedStoryboard.instantiateViewController(withIdentifier: identifier)
            
            // Try to cast it to feed item view controller
            guard let feedItemViewController = viewController as? FeedItemViewController else {
                debug("WARNING: Can't cast \(viewController) to \(FeedItemViewController.self)")
                return
            }
            
            feedItemViewController.configure(kind, with: items[kind], named: feedHeader.title)
            wishlistNavigationController.pushViewController(feedItemViewController, animated: true)
            return
        }
        
        // Check if feed item cell was tapped
        if let feedItem = sender as? FeedItem {
            // Check if we came from wish list
            guard let wishlistNavigationController = parentNavigationController else {
                performSegue(withIdentifier: ItemViewController.segueIdentifier, sender: feedItem)
                return
            }
            
            // Instantiate a view controller from wishlist storyboard
            let wishlistStoryboard = UIStoryboard(name: "Wishlist", bundle: nil)
            let identifier = String(describing: ItemViewController.self).decapitalizingFirstLetter
            let viewController = wishlistStoryboard.instantiateViewController(withIdentifier: identifier)
            
            // Try to cast it to item view controller
            guard let itemViewController = viewController as? ItemViewController else {
                debug("WARNING: Can't cast \(viewController) to \(ItemViewController.self)")
                return
            }
            
            // Configure and push item view controller
            itemViewController.configure(with: feedItem.item, image: feedItem.itemImageView.image)
            wishlistNavigationController.pushViewController(itemViewController, animated: true)
            return
        }
        
        debug("WARNING: Can't cast \(sender) to \(FeedSectionHeaderView.self)")
    }
}
