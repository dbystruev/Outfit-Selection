//
//  FeedViewController+ButtonDelegate.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 26.08.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

extension FeedViewController: ButtonDelegate {
    func buttonTapped(_ sender: Any) {
        // Obtain the feed cell where the button was tapped
        guard let feedCell = sender as? FeedCell else { return }
        
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
