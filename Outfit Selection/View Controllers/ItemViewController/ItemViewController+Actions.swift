//
//  ItemViewController+Actions.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 16.03.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import UIKit

// MARK: - Actions
extension ItemViewController {
    @IBAction func addToCollectionButton(_ sender: UIButton) {
        debug(item, sender)
    }
    
    @IBAction func addToWishlistButtonTapped(_ sender: WishlistButton) {
        guard let item = item else { return }
        sender.addToWishlistButtonTapped(for: item)
    }
    
    @IBAction func dislikeButtonTapped(_ sender: WishlistButton) {
        guard let item = item else { return }
        present(Alert.dislike(item, handler: { _ in
            sender.dislikeButtonTapped(for: item)
            self.navigationController?.popViewController(animated: true)
        }), animated: true)
    }
    
    @IBAction func orderButtonTapped(_ sender: UIButton) {
        guard let url = item?.url else { return }
        self.url = url
        performSegue(withIdentifier: "intermediaryViewControllerSegue", sender: sender)
    }
    
    @IBAction func shareButtonTapped(_ sender: UIBarButtonItem) {
        // Make sure item url is not nil
        guard let itemURL = item?.url else { return }
        
        // Share item url
        let activityController = UIActivityViewController(activityItems: [itemURL], applicationActivities: nil)
        activityController.popoverPresentationController?.sourceView = sender.customView
        present(activityController, animated: true)
    }
}
