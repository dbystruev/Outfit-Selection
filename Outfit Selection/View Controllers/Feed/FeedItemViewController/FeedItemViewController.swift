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
    var items: Items = []
    
    /// Items download
    var itemsDownloaded: Bool = false
    
    /// Section (type) of the items
    var section: PickType = .newItems
    
    /// Pick of the items
    var pick: Pick = Pick(.hello, title: "")
    
    /// Name of the feed
    var name: String?
    
    // MARK: - Custom Methods
    /// Configure with feed collection view controller
    /// - Parameters:
    ///   - pick: feed item collection type (pick)
    ///   - items: the list of included items
    ///   - name: name of the collection
    func configure(_ pick: Pick, with items: Items?, named name: String?) {
        self.pick = pick
        self.name = name
        self.items = items ?? []
    }
    
    /// Configure with feed collection view controller
    /// - Parameters:
    ///   - kind: feed item collection type (kind)
    ///   - items: the list of included items
    ///   - name: name of the collection
    func configure(_ section: PickType, with items: Items?, named name: String?) {
        self.section = section
        self.name = name
        self.items = items ?? []
    }
    
    // MARK: - Inherited Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register feed item collection view cell for dequeue
        itemCollectionView.register(
            FeedItemCollectionCell.self,
            forCellWithReuseIdentifier: FeedItemCollectionCell.reuseId
        )
        
        // Use self as source for data
        itemCollectionView.dataSource = self
        
        // Set custom collection view layout
        itemCollectionView.setCollectionViewLayout(itemCollectionViewLayout, animated: false)
        
        // Hide scroll indicator
        itemCollectionView.showsVerticalScrollIndicator = false
        
        // Update the name of the feed
        titleLabel.text = name
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Make sure like buttons are updated when we come back from item screen
        itemCollectionView.visibleCells.forEach {
            ($0 as? FeedItemCollectionCell)?.configureLikeButton()
        }
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        itemCollectionViewLayout.sizeViewWillTransitionTo = size
    }
    
  
}
