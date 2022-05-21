//
//  CollectionSelectViewController.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 06.09.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import UIKit

class CollectionSelectViewController: CollectionBaseViewController {
    // MARK: - Static Properties
    static weak var collectionView: UICollectionView?
    
    // MARK: - Outlets
    @IBOutlet weak var chooseItemsButton: UIButton! {
        didSet {
            wishlistViewController?.chooseItemsButton = chooseItemsButton
        }
    }
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            CollectionSelectViewController.collectionView = collectionView
        }
    }
    
    // MARK: - Inherited Methods
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        // Reset items count
        wishlistViewController?.wishListItemsCount = 0
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Disable a chooseItemsButton
        chooseItemsButton.backgroundColor = Global.Color.Button.disabled
        chooseItemsButton.isEnabled = false
        
        // Setup collection view
        collectionView.allowsMultipleSelection = true
        collectionView.dataSource = wishlistViewController
        collectionView.delegate = wishlistViewController
    }
    
}
