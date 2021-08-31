//
//  FeedViewController.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 18.08.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var feedTableView: UITableView!
    
    // MARK: - Stored Properties
    /// Saved brand cell margins and paddings
    var savedBrandCellConstants: (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)
    
    /// Selected brand names to be changed every time the brand is selected / unselected
    var selectedBrandNames = BrandManager.shared.brandedImages.selected.brandNames
    
    // MARK: - Custom Methods
    func reloadData() {
        selectedBrandNames = BrandManager.shared.brandedImages.selected.brandNames
        feedTableView.reloadData()
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
            
        case ItemViewController.segueIdentifier:
            guard let destination = segue.destination as? ItemViewController else {
                debug("Can't cast \(segue.destination) to ItemViewController")
                return
            }
            
            guard let feedItem = sender as? FeedItem else {
                debug("Can't cast \(String(describing: sender)) to FeedItem")
                return
            }
            
            guard let itemIndex = feedItem.item?.itemIndex else {
                debug("Can't get an item index from \(feedItem)")
                return
            }
            
            destination.image = feedItem.itemImageView.image
            destination.itemIndex = itemIndex
            
        default:
            debug("Unknown segue id \(String(describing: segue.identifier))")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register feed cell with feed table view
        FeedBrandCell.register(with: feedTableView)
        FeedItemCell.register(with: feedTableView)
        
        // Set self as feed table view data source and delegate
        feedTableView.dataSource = self
        feedTableView.delegate = self
        
        // Remove separator lines between the cells
        feedTableView.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Set margins and paddings for brand cell
        savedBrandCellConstants = (BrandCell.horizontalMargin, BrandCell.horizontalPadding, BrandCell.verticalMargin, BrandCell.verticalPadding)
        BrandCell.horizontalMargin = 0 * FeedBrandCell.designFactor
        BrandCell.horizontalPadding = 20 * FeedBrandCell.designFactor
        BrandCell.verticalMargin = 0 * FeedBrandCell.designFactor
        BrandCell.verticalPadding = 20 * FeedBrandCell.designFactor
        
        // Make sure like buttons are updated when we come back from see all screen
        feedTableView.visibleCells.forEach {
            ($0 as? FeedItemCell)?.configureLikeButtons()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Restore margins and paddings for brand cell
        (BrandCell.horizontalMargin, BrandCell.horizontalPadding, BrandCell.verticalMargin, BrandCell.verticalPadding) = savedBrandCellConstants
    }
}
