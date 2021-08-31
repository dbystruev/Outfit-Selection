//
//  FeedViewController+ButtonDelegate.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 26.08.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

extension FeedViewController: ButtonDelegate {
    func buttonTapped(_ sender: Any) {
        // Check if the button was tapped in the feed brand cell
        if let brandedImage = sender as? BrandedImage {
            reloadData(first: brandedImage.isSelected ? brandedImage.brandName : nil)
        } else
        
        // Check if the button was tapped in the feed item cell
        if let feedItem = sender as? FeedItem {
            performSegue(withIdentifier: ItemViewController.segueIdentifier, sender: feedItem)
        } else
        
        // Check if `see all` button was tapped in the feed item cell
        if let feedItemCell = sender as? FeedItemCell {
            performSegue(withIdentifier: FeedItemViewController.segueIdentifier, sender: feedItemCell)
        }
    }
}
