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
    @IBOutlet weak var collectionNameLabel: UILabel! {
        didSet {
            wishlistViewController?.collectionNameLabel = collectionNameLabel
        }
    }
    
    @IBOutlet weak var chooseItemsButton: UIButton! {
        didSet {
            debug()
        }
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Inherited Methods
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        collectionNameLabel.text = "Add something to collection"~
//        + " "
//        + (collectionName ?? "collection"~)
        
        // Set data source and flow layout delegate for collection view
        collectionView.dataSource = wishlistViewController
        collectionView.delegate = wishlistViewController
    }
}
