//
//  FeedViewController+ButtonDelegate.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 26.08.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

extension FeedViewController: ButtonDelegate {
    func buttonTapped(_ sender: Any) {
        // Check if the the button was tapped in the feed cell
        if let feedCell = sender as? FeedCell {
            seeAllButtonTapped(in: feedCell)
            return
        }
        
        // Check if the button was tapped in the feed item
        guard let feedItem = sender as? FeedItem else { return }
        
        debug(feedItem.item?.name)

    }
    
    /// Called when `see all` button was tapped in the feed cell
    /// - Parameter feedCell: feed cell in which the `see all` button was tapped
    func seeAllButtonTapped(in feedCell: FeedCell) {
        // Perform different actions based on feed cell type (kind)
        switch feedCell.kind {
        
        case .brands:
            // Check that feed brand cell is sending this message
            guard feedCell is FeedBrandCell else { return }
            reloadData()
            
        case .newItems, .sale:
            // Check that indeed we have feed item cell before performing the segue
            guard let feedItemCell = feedCell as? FeedItemCell else { return }
            performSegue(withIdentifier: FeedItemViewController.segueIdentifier, sender: feedItemCell)
        }
    }
}
