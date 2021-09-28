//
//  FeedTableViewController.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 18.08.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import UIKit

class FeedTableViewController: LoggingViewController {
    // MARK: - Outlets
    @IBOutlet weak var feedTableView: UITableView!
    
    // MARK: - Stored Properties
    /// Types and titles of cells to show in table view
    var cellDatas: [(kind: FeedKind, title: String, items: [Item])] = []
    
    /// Saved brand cell margins and paddings
    var savedBrandCellConstants: (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)
    
    /// Selected brand names to be changed every time the brand is selected / unselected
    var selectedBrandNames = BrandManager.shared.brandedImages.selected.brandNames
    
    // MARK: - Custom Methods
    /// Reload data in feed table view, putting brand name to the beginning if it is not nil
    /// - Parameter brandName: brand name, nil be default
    func reloadData(first brandName: String? = nil) {
        selectedBrandNames = BrandManager.shared.brandedImages.selected.brandNames
        if let brandName = brandName {
            selectedBrandNames.sort { $0 == brandName || $0 < $1 }
        }
        NetworkManager.shared.reloadItems(for: Gender.current) { success in
            guard success == true else { return }
            DispatchQueue.main.async {
                self.feedTableView.reloadData()
            }
        }
    }
    
    /// Register cells, set data source and delegate for a given table view
    /// - Parameter tableView: table view to setup
    func setup(_ tableView: UITableView, kinds: [FeedKind]) {
        // Register feed cell with feed table view
        FeedBrandCell.register(with: tableView)
        FeedItemCell.register(with: tableView)
        
        // Type and number of cells to show in table view
        cellDatas = kinds.map {(kind: $0, title: $0.title, items: [])}
        
        // Set self as feed table view data source and delegate
        tableView.dataSource = self
        tableView.delegate = self
        
        // Remove separator lines between the cells
        tableView.separatorStyle = .none
    }
    
    // MARK: - Inherited Methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Perform different preparations depending on segue ids sent
        switch segue.identifier {
            
        case FeedItemViewController.segueIdentifier:
            guard let feedItemCell = sender as? FeedItemCell else {
                debug("Can't cast \(String(describing: sender)) to FeedItemCell")
                return
            }
            
            guard let feedItemViewController = segue.destination as? FeedItemViewController else {
                debug("Can't cast \(segue.destination) to FeedItemViewController")
                return
            }
            
            feedItemViewController.items = feedItemCell.items
            feedItemViewController.kind = feedItemCell.kind
            feedItemViewController.name = feedItemCell.name
            
        case ItemViewController.segueIdentifier:
            guard let destination = segue.destination as? ItemViewController else {
                debug("Can't cast \(segue.destination) to ItemViewController")
                return
            }
            
            guard let feedItem = sender as? FeedItem else {
                debug("Can't cast \(String(describing: sender)) to FeedItem")
                return
            }
            
            destination.image = feedItem.itemImageView.image
            destination.item = feedItem.item
            
        default:
            debug("Unknown segue id \(String(describing: segue.identifier))")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register cells, set data source and delegate for a feed table view
        setup(feedTableView, kinds: FeedKind.allCases.filter { $0 != .occasions })
        
        // Go through the list of seleced occasions and add them to feed table view
        Occasion.selected.forEach {
            // Suggest items for the occasion (temporary random)
            let shuffledItems = Item.all.values.shuffled()
            
            // Make sure we don't have more than 42 of them
            let numberOfItems = min(42, shuffledItems.count)
            
            // Take the first number of items for the occasion
            let items = Array(shuffledItems[..<numberOfItems])
            
            // Append the occasion to the list of cells
            cellDatas.append((kind: .occasions, title: "Occasion: \($0.name)", items: items))
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Set margins and paddings for brand cell
        savedBrandCellConstants = (BrandCollectionViewCell.horizontalMargin, BrandCollectionViewCell.horizontalPadding, BrandCollectionViewCell.verticalMargin, BrandCollectionViewCell.verticalPadding)
        BrandCollectionViewCell.horizontalMargin = 0 * FeedBrandCell.designFactor
        BrandCollectionViewCell.horizontalPadding = 20 * FeedBrandCell.designFactor
        BrandCollectionViewCell.verticalMargin = 0 * FeedBrandCell.designFactor
        BrandCollectionViewCell.verticalPadding = 20 * FeedBrandCell.designFactor
        
        // Make sure like buttons are updated when we come back from see all screen
        feedTableView.visibleCells.forEach {
            ($0 as? FeedItemCell)?.configureLikeButtons()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Restore margins and paddings for brand cell
        (BrandCollectionViewCell.horizontalMargin, BrandCollectionViewCell.horizontalPadding, BrandCollectionViewCell.verticalMargin, BrandCollectionViewCell.verticalPadding) = savedBrandCellConstants
    }
}
