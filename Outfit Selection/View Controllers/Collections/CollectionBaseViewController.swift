//
//  CollectionBaseViewController.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 06.09.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import UIKit

class CollectionBaseViewController: UIViewController {

    // MARK: - Stored Properties
    /// Items which potentially could be added to newly created collection if the user selects them
    var collectionItems: [CollectionItem] = [] {
        didSet {
            debug(collectionItems.count, collectionItems.map { ($0.kind, $0.items.count) })
        }
    }
    
    /// Collection name entered by the user
    var collectionName: String? {
        didSet {
            debug(collectionName)
        }
    }
    
    /// Wishlist view controller which modally presented ourselves
    var wishlistViewController: WishlistViewController?

    // MARK: - Actions
    @IBAction func closeButtonTapped(_ sender: UIButton) {
        debug()
        dismiss(animated: true)
    }
}
