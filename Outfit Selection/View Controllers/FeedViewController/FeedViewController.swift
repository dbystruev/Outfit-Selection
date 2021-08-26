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
    var savedConstants: (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)
    
    // MARK: - Inherited Methods
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
        super.viewWillDisappear(animated)
        
        // Set margins and paddings for brand cell
        savedConstants = (BrandCell.horizontalMargin, BrandCell.horizontalPadding, BrandCell.verticalMargin, BrandCell.verticalPadding)
        BrandCell.horizontalMargin = 0 * FeedBrandCell.designFactor
        BrandCell.horizontalPadding = 20 * FeedBrandCell.designFactor
        BrandCell.verticalMargin = 0 * FeedBrandCell.designFactor
        BrandCell.verticalPadding = 20 * FeedBrandCell.designFactor
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Restore margins and paddings for brand cell
        (BrandCell.horizontalMargin, BrandCell.horizontalPadding, BrandCell.verticalMargin, BrandCell.verticalPadding) = savedConstants
    }
    
}
