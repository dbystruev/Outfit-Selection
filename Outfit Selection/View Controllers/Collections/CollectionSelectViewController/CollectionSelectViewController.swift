//
//  CollectionSelectViewController.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 06.09.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import UIKit

class CollectionSelectViewController: CollectionBaseViewController {
    // MARK: - Outlets
    @IBOutlet weak var chooseItemsButton: UIButton! {
        didSet {
            wishlistViewController?.chooseItemsButton = chooseItemsButton
        }
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Inherited Methods
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Disable a chooseItemsButton
        chooseItemsButton.backgroundColor = Globals.Color.Button.disabled
        chooseItemsButton.isEnabled = false
        
        // Load wishlist
        collectionView.dataSource = wishlistViewController
        collectionView.delegate = wishlistViewController
    }
    
}
