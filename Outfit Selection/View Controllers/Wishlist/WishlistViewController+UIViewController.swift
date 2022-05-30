//
//  WishlistViewController+UIViewController.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 07.09.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import UIKit

// MARK: - UIViewController Inherited Methods
extension WishlistViewController {
    
    // MARK: - Inherited Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure navigation controller's bar font
        navigationController?.configureFont()
        
        // Register cells, set data source and delegate for collections table view
        feedController.setup(collectionsCollectionView)
        feedController.parentNavigationController = navigationController
        
        // Register feed item collection cell with wishlist collection view
        FeedItemCollectionCell.register(with: wishlistCollectionView)
        
        // Fill feed controller with collections and items
        Collection.all.forEach { collection in
            feedController.addSection(items: collection.items, to: .collections(collection.name))
        }
        
        // Set data source and delegate for wish list collection view
        wishlistCollectionView.dataSource = self
        wishlistCollectionView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        selectSuggestedTab()
        updateUI()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        updateUI(isHorizontal: size.height < size.width)
    }
}
