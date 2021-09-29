//
//  FeedItemViewController.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 26.08.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import UIKit

class FeedItemViewController: LoggingViewController {

    // MARK: - Outlets
    @IBOutlet weak var itemCollectionView: UICollectionView!
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: - Stored Properties
    /// Collection view layout for the item collection view
    let itemCollectionViewLayout = FeedItemCollectionViewLayout()
    
    /// Items to display in the item collection view
    var items: [Item] = []
    
    /// Kind (type) of the items
    var kind: FeedKind = .newItems
    
    /// Name of the feed
    var name: String?
    
    // MARK: - Inherited Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register feed item collection view cell for dequeue
        itemCollectionView.register(
            FeedCollectionViewCell.self,
            forCellWithReuseIdentifier: FeedCollectionViewCell.reuseId
        )
        
        // Use self as source for data
        itemCollectionView.dataSource = self
        
        // Set custom collection view layout
        itemCollectionView.setCollectionViewLayout(itemCollectionViewLayout, animated: false)
        
        // Update the name of the feed
        titleLabel.text = name
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Make sure like buttons are updated when we come back from item screen
        itemCollectionView.visibleCells.forEach {
            ($0 as? FeedCollectionViewCell)?.configureLikeButton()
        }
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        itemCollectionViewLayout.sizeViewWillTransitionTo = size
    }
}
