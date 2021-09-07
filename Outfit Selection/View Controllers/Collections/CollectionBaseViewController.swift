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
    /// Collection name entered by the user
    var collectionName: String?
    
    /// Wishlist view controller which modally presented ourselves
    weak var wishlistViewController: WishlistViewController?

    // MARK: - Actions
    @IBAction func closeButtonTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }
}
