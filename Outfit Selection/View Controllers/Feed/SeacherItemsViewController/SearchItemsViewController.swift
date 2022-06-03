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
    
    /// length for generate string for get randome items
    let length: Int = 1
    
    /// The limit of count items after request
    let limited = 25
    
    /// Parent navigation controller if called from another view controller
    var parentNavigationController: UINavigationController?
    
    /// Items for searchBar
    var searchItems: Items?
    
    // MARK: - Private Methods
    /// Get random items for table view
    func setRandomItems() {
        NetworkManager.shared.getItems(for: Gender.current, limited: limited, named: randomString(length: length)) { items in
            guard let items = items else { return }
            self.searchItems = items
            
            DispatchQueue.main.async {
                guard !items.isEmpty else { return }
                
                if AppDelegate.canReload && self.searchTableView?.hasUncommittedUpdates == false {
                    self.searchTableView?.reloadData()
                }
            }
        }
    }
    
    // MARK: - Helper Methods
    /// Generating random string
    /// - Parameter length: count character
    /// - Returns: random string
    private func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
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
