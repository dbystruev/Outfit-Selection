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
        guard !wishlist.isEmpty else {
            present(Alert.noItems, animated: true)
            return
        }
        
        // If not — jump to creating new collection
        performSegue(withIdentifier: CollectionNameViewController.segueIdentifier, sender: self)
    }
    
    @IBAction func collectionsButtonTapped(_ sender: UIButton) {
        tabSelected = .collection
    }
    
    @IBAction func itemsButtonTapped(_ sender: UIButton) {
        tabSelected = .item
    }
    
    @IBAction func outfitsButtonTapped(_ sender: UIButton) {
        tabSelected = .outfit
    }
}

