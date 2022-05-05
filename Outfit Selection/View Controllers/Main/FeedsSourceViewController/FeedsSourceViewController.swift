//
//  FeedsSourceViewController.swift
//  Outfit Selection
//
//  Created by Evgeniy Goncharov on 04.05.2022.
//  Copyright © 2022 Denis Bystruev. All rights reserved.
//

import UIKit

class FeedsSourceViewController: UIViewController {
    
    // MARK: - Outlets
    /// Top right button to clear or select all brands
    @IBOutlet weak var allButton: SelectableButtonItem!
    
    /// The main table view with occasion list
    @IBOutlet weak var feedsTableView: UITableView!
    
    /// The UIButton for save selected feeds
    @IBOutlet weak var saveButton: UIButton!
    
    // MARK: - Stored Properties
    /// Array of feedsSource names
    var feedsSourceNames: [String] = []
    
    

    // MARK: - Custom Methods
    /// Set go button background color and enable / disable it depending on number of feeds selected
    func configureSaveButton() {
        let shouldUse = FeedsSource.all.selected.count
        let isEnabled = 0 < shouldUse
        saveButton?.backgroundColor = isEnabled
        ? Globals.Color.Button.enabled
        : Globals.Color.Button.disabled
        saveButton?.isEnabled = isEnabled
    }
    
    // MARK: - Inherited Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Hide tabBar
        hideTabBar()

        // Hide back button
        navigationItem.hidesBackButton = isEditing
        
        // Set new backButton into leftBarButtonItem
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel"~, style: .plain, target: self, action: #selector(cancelButtonTap))
        
        // Set title
        self.title = "Feeds"~
        
        // Sate name for save button
        saveButton.setTitle("Save"~, for: .normal)
        
        // Hide tabBar
        tabBarController?.tabBar.isHidden = true
        
        // Setup data source
        let currentFeedsSource = FeedsSource.all
        feedsSourceNames = currentFeedsSource.names.sorted()
        
        // Setup occasions table view
        feedsTableView.dataSource = self
        feedsTableView.delegate = self
        feedsTableView.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Configure UI
        configureSaveButton()
    }
}
