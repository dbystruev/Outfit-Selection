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
    /// Marker for activate editMode
    var editMode: Bool = false
    
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
    ///   - section: feed item collection type (kind)
    ///   - items: the list of included items
    ///   - name: name of the collection
    ///   - mode: the marker for set button into barButton item
    func configure(_ section: PickType, with items: Items?, named name: String?, edit mode: Bool = false) {
        self.section = section
        self.name = name
        self.items = items ?? []
        self.editMode = mode
    }
    
    /// Configure buttoms for barButtonItem
    func configureBarButtonItems() {
        // Share buttom
        let share = UIBarButtonItem(
            image: UIImage(named: "share")?.withRenderingMode(.alwaysTemplate),
            style: .plain, target: self,
            action: #selector(shareButtonTapped)
        )
        
        let edit = editButtonItem
        navigationItem.rightBarButtonItems = [share, edit]
    }
    
    /// Configure buttoms for barButtonItem
    func configureBarEditButtons() {
        // Cancel buttom
        let cancel = UIBarButtonItem(
            title: "Cancel"~,
            style: .plain,
            target: self,
            action: #selector(cancelButtonTapped)
        )
        
        // Delete buttom
        let delete = UIBarButtonItem(
            title: "Delete"~,
            style: .plain,
            target: self,
            action: #selector(showAlert)
        )
        // Set color for UIBarButtonItem
        delete.tintColor = .red
        
        // Save buttom
        let save = UIBarButtonItem(
            title: "Save"~,
            style: .plain,
            target: self,
            action: #selector(saveButtonTapped)
        )
        save.isEnabled = false
        
        navigationItem.rightBarButtonItems = [save ,delete, cancel]
    }
    
    /// Configure Like Button
    func configureLikeButton() {
        // Make sure like buttons are updated when we come back from item screen
        itemCollectionView.visibleCells.forEach {
            ($0 as? FeedItemCollectionCell)?.configureLikeButton()
        }
    }
    
    // MARK: - Inherited Methods
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        if editing {
            configureBarEditButtons()
            editButtonTapped(self)
        } else {
            configureBarButtonItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if editMode {
            configureBarButtonItems()
        }
        
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
        configureLikeButton()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        itemCollectionViewLayout.sizeViewWillTransitionTo = size
    }

}
