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
    
    // MARK: - Inherited Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register feed cell with feed table view
        FeedCell.register(with: feedTableView)
        
        // Set self as feed table view data source and delegate
        feedTableView.dataSource = self
        feedTableView.delegate = self
    }
    
}
