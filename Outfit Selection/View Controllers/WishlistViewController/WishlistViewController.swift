//
//  WishlistViewController.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 25.02.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import UIKit

class WishlistViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var collectionsButton: UIButton!
    @IBOutlet weak var collectionsTableView: UITableView!
    @IBOutlet weak var collectionsUnderline: UIView!
    @IBOutlet var createCollectionButton: UIBarButtonItem! // strong in order to add / delete
    @IBOutlet weak var itemsButton: UIButton!
    @IBOutlet weak var itemsUnderline: UIView!
    @IBOutlet weak var outfitsButton: UIButton!
    @IBOutlet weak var outfitsUnderline: UIView!
    @IBOutlet weak var wishlistCollectionView: UICollectionView!
    
    // CollectionSelectViewController outlet
    weak var collectionNameLabel: UILabel?
    
    // MARK: - Computed Properties
    /// Get outfit view controller
    var outfitViewController: OutfitViewController? {
        let navigationController = tabBarController?.viewControllers?.first as? UINavigationController
        return navigationController?.viewControllers.first as? OutfitViewController
    }
    
    /// Either items or outfits wishlist depending on whether the items tab is selected
    var wishlist: [Wishlist] {
        switch tabSelected {
        case .collection:
            return []
        case .item:
            return Wishlist.items
        case .outfit:
            return Wishlist.outfits
        }
    }
    
    /// Either items or outfit cell depending on whether the items tab is selected
    var wishlistCellId: String {
        switch tabSelected {
        case .collection:
            return "collectionItemCell"
        case .item:
            return "itemCell"
        case .outfit:
            return "outfitCell"
        }
    }
    
    // MARK: - Stored Properties
    /// Number of cells to show per row: 2 for vertical and 4 for horizontal orientations
    var cellsPerRow = 2
    
    /// Collections the user creates
    var collections: [Collection] = [] {
        didSet {
            debug("\(collections.count): \(collections.map { $0.name })")
        }
    }
    
    /// Feed view controller used as data source and table delegate for collection table view
    let feedController = FeedViewController()
    
    /// Contains the currently selected tab: collections, items, or outfits
    var tabSelected: WishlistItem.Kind = .item {
        didSet {
            Wishlist.tabSuggested = tabSelected
            updateUI()
        }
    }
    
    // MARK: - Custom Methods
    /// Called when user finished selecting items or outfits for new collection
    func finishSelectingCollectionItems() {
        guard let lastCollection = collections.last else { return }
        
        // Check if last collection is empty and remove it
        guard !lastCollection.isEmpty else {
            collections.removeLast()
            return
        }
        
        // Add new collection to collection table view source
        feedController.cellDatas.append((kind: .newItems, title: lastCollection.name, items: lastCollection.items))
    }
    
    /// Select the suggested tab
    func selectSuggestedTab() {
        tabSelected = Wishlist.tabSuggested
    }
    
    /// Update items or outfits displayed depending on items selected state
    func updateUI(isHorizontal: Bool? = nil) {
        // Set the number of cells per row
        let size = view.bounds.size
        let isHorizontal = isHorizontal ?? (size.height < size.width)
        cellsPerRow = isHorizontal ? 4 : 2
        
        // Update buttons visibility
        collectionsButton.titleLabel?.alpha = tabSelected == .collection ? 1 : 0.5
        collectionsUnderline.isHidden = tabSelected != .collection
        itemsButton.titleLabel?.alpha = tabSelected == .item ? 1 : 0.5
        itemsUnderline.isHidden = tabSelected != .item
        outfitsButton.titleLabel?.alpha = tabSelected == .outfit ? 1 : 0.5
        outfitsUnderline.isHidden = tabSelected != .outfit
        
        // Remove / add create collection button from / to toolbar depending on presense of wishlist items / outfits
        if wishlist.isEmpty {
            navigationItem.rightBarButtonItems?.removeAll { $0 == createCollectionButton }
        } else if navigationItem.rightBarButtonItems?.contains(createCollectionButton) == false {
            navigationItem.rightBarButtonItems?.append(createCollectionButton)
        }
        
        // Make visible and reload either collection table view or wishlist collection view
        collectionsTableView.isHidden = tabSelected != .collection
        wishlistCollectionView.isHidden = tabSelected == .collection
        if tabSelected == .collection {
            collectionsTableView.reloadData()
        } else {
            wishlistCollectionView.reloadData()
        }
    }
}
