//
//  SearchItemsViewController.swift
//  Outfit Selection
//
//  Created by Evgeniy Goncharov on 31.05.2022.
//  Copyright © 2022 Denis Bystruev. All rights reserved.
//

import UIKit

class SearchItemsViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var cancelUIButton: UIButton!
    @IBOutlet weak var searchTableView: UITableView!
    
    // MARK: - Properties
    /// Time of last click in search bar
    var lastClick: Date?
    
    /// The limit of count items after request
    let limited = 25
    
    /// Items for searchBar
    var searchItems: Items?
    
    // MARK: - Inherited Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure the items table view
        searchTableView.dataSource = self
        searchTableView.delegate = self
        
        // UISheetPresentation 
        if #available(iOS 15.0, *) {
            if let presentationController = presentationController as? UISheetPresentationController {
                presentationController.detents = [.medium(), .large()]
                presentationController.prefersGrabberVisible = true
            }
        }
    }
}
