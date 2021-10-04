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
            if let parentNavigationController = parentNavigationController {
                let feedStoryboard = UIStoryboard(name: "Feed", bundle: nil)
                let identifier = String(describing: FeedItemViewController.self).decapitalizingFirstLetter
                let viewController = feedStoryboard.instantiateViewController(withIdentifier: identifier)
                guard let feedItemViewController = viewController as? FeedItemViewController else {
                    debug("WARNING: Can't cast \(viewController) to \(FeedItemViewController.self)")
                    return
                }
                let kind = feedHeader.kind
                feedItemViewController.configure(kind, with: items(for: kind), named: feedHeader.title)
                parentNavigationController.pushViewController(feedItemViewController, animated: true)
            } else {
                performSegue(withIdentifier: FeedItemViewController.segueIdentifier, sender: feedHeader)
            }
            return
        }
        
        // Check if feed item cell was tapped
        if let feedItem = sender as? FeedItem {
            performSegue(withIdentifier: ItemViewController.segueIdentifier, sender: feedItem)
            return
        }
        
        debug("WARNING: Can't cast \(sender) to \(FeedSectionHeaderView.self)")
    }
}
