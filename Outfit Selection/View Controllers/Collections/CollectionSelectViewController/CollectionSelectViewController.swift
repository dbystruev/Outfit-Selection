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
    @IBOutlet weak var collectionNameLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Static Properties
    static let segueIdentifier = "collectionSelectViewControllerSegue"
    
    // MARK: - Inherited Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionNameLabel.text = "Select items for \(collectionName ?? "collection")"
        
        // Set data source and flow layout delegate for collection view
        collectionView.dataSource = wishlistViewController
        collectionView.delegate = wishlistViewController
    }

}
