//
//  FeedCollectionViewController.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 27.09.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import UIKit

class FeedCollectionViewController: LoggingViewController {
    // MARK: - Outlets
    @IBOutlet weak var feedCollectionView: UICollectionView!
    
    // MARK: - UIViewController Inherited Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register collection view cells
        feedCollectionView.register(BrandCollectionViewCell.nib, forCellWithReuseIdentifier: BrandCollectionViewCell.reuseId)
        feedCollectionView.register(
            FeedItemCollectionViewCell.self, forCellWithReuseIdentifier: FeedItemCollectionViewCell.reuseId
        )
        
        debug("DEBUG: Collection view cells have been registered")
    }
}
