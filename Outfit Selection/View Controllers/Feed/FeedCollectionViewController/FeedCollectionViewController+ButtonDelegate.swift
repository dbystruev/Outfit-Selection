//
//  FeedCollectionViewController+ButtonDelegate.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 29.09.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

extension FeedCollectionViewController: ButtonDelegate {
    func buttonTapped(_ sender: Any) {
        guard let feedHeader = sender as? FeedSectionHeaderView else {
            debug("WARNING: Can't cast \(sender) to \(FeedSectionHeaderView.self)")
            return
        }
        
        // `see all` button was tapped in the feed item cell
        performSegue(withIdentifier: FeedItemViewController.segueIdentifier, sender: feedHeader)
    }
}
