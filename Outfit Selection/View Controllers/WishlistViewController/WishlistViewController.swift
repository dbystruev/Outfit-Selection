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
    @IBOutlet weak var collectionsUnderline: UIView!
    @IBOutlet var createCollectionButton: UIBarButtonItem! // strong in order to add / delete
    @IBOutlet weak var itemsButton: UIButton!
    @IBOutlet weak var itemsUnderline: UIView!
    @IBOutlet weak var outfitsButton: UIButton!
    @IBOutlet weak var outfitsUnderline: UIView!
    @IBOutlet weak var wishlistCollectionView: UICollectionView!
    
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
    
    /// Contains the currently selected tab: collections, items, or outfits
    var tabSelected: Wishlist.Tab = .item {
        didSet {
            Wishlist.tabSuggested = tabSelected
            updateUI()
        }
    }
    
    // MARK: - Custom Methods
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
        
        // Reload collection view
        wishlistCollectionView.reloadData()
    }
    
    // MARK: - Inherited Methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        
        case ItemViewController.segueIdentifier:
            guard let destination = segue.destination as? ItemViewController else { return }
            guard let selectedIndexPath = wishlistCollectionView.indexPathsForSelectedItems?.first else { return }
            guard let itemCell = wishlistCollectionView.cellForItem(at: selectedIndexPath) as? ItemCell else { return }
            guard let itemIndex = wishlist[selectedIndexPath.row].item?.itemIndex else { return }
            destination.image = itemCell.pictureImageView.image
            destination.itemIndex = itemIndex
            
        case CollectionNameViewController.segueIdentifier:
            guard let destination = segue.destination as? CollectionNameViewController else {
                debug("WARNING: \(segue.destination) is not CollectionsViewController")
                return
            }
            
            // Use wishlist items or outfits to create new collection items
            destination.collectionItems = wishlist.compactMap { $0.kind == .item ? CollectionItem($0.item) : CollectionItem($0.items) }
            destination.source = self
            
        case CollectionSelectViewController.segueIdentifier:
            guard let destination = segue.destination as? CollectionSelectViewController else {
                debug("WARNING: \(segue.destination) is not CollectionSelectViewController")
                return
            }
            
            guard let sender = sender as? CollectionNameViewController else {
                debug("WARNING: \(String(describing: sender)) is not CollectionNameViewController")
                return
            }
            
            // Use wishlist items or outfits to create new collection items
            destination.collectionItems = sender.collectionItems
            destination.collectionName = sender.collectionName
            
        default:
            debug("WARNING: Unknown segue identifier", segue.identifier)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure navigation controller's bar font
        navigationController?.configureFont()
        
        // Set data source and delegate for wish list
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
