//
//  WishlistViewController+Actions.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 06.09.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import UIKit

// MARK: - Actions
extension WishlistViewController {
    @IBAction func createCollectionButtonTapped(_ sender: UIBarButtonItem) {
        // Check that wishlist is not empty
        guard !Wishlist.items.isEmpty else {
            present(Alert.noItems, animated: true)
            return
        }
        
        // If not — jump to creating new collection
        performSegue(withIdentifier: CollectionsViewController.segueIdentifier, sender: self)
    }
    
    @IBAction func collectionsButtonTapped(_ sender: UIButton) {
        tabSelected = .collections
    }
    
    @IBAction func itemsButtonTapped(_ sender: UIButton) {
        tabSelected = .items
    }
    
    @IBAction func outfitsButtonTapped(_ sender: UIButton) {
        tabSelected = .outfits
    }
}

