//
//  FeedCollectionViewController+ButtonDelegate.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 29.09.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

extension FeedCollectionViewController: ButtonDelegate {
    func buttonTapped(_ sender: Any) {
        // Check if `see all` button was tapped in the feed section header
        if let feedHeader = sender as? FeedSectionHeaderView {
            performSegue(withIdentifier: FeedItemViewController.segueIdentifier, sender: feedHeader)
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
