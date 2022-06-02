//
//  FeedsProfileViewController.swift
//  Outfit Selection
//
//  Created by Evgeniy Goncharov on 04.05.2022.
//  Copyright © 2022 Denis Bystruev. All rights reserved.
//

import UIKit

class FeedsProfileViewController: UIViewController {
    
    // MARK: - Outlets
    /// Top right button to clear or select all brands
    @IBOutlet weak var allButton: SelectableButtonItem!
    
    /// The main table view with occasion list
    @IBOutlet weak var feedsTableView: UITableView!
    
    /// The UIButton for save selected feeds
    @IBOutlet weak var saveButton: UIButton!
    
    // MARK: - Stored Properties
    /// Array of feedsSource names
    var feedsProfileNames: [String] = []
    
    /// Save selected feedProfile when start viewController
    var feedProfileSelectedFeedsIDs: [String] = []
    
    /// Notification name feedProfileChanged
    let nameNotification = Global.Notification.name.feedProfileChanged
    
    // MARK: - Custom Methods
    /// Set top right button to clear or select all
    func configureAllButton() {
        let feedsSource = FeedsProfile.all
        allButton.isButtonSelected = feedsSource.unselected.count < feedsSource.selected.count
    }
    /// Set go button background color and enable / disable it depending on number of feeds selected
    func configureSaveButton() {
        let shouldUse = FeedsProfile.all.selected.count
        let isEnabled = 0 < shouldUse
        saveButton?.backgroundColor = isEnabled
        ? Global.Color.Button.enabled
        : Global.Color.Button.disabled
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
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel"~, style: .plain, target: self, action: #selector(cancelButtonTapped))
        
        // Set title
        self.title = "Feeds"~
        
        // Sate name for save button
        saveButton.setTitle("Save"~, for: .normal)
        
        // Hide tabBar
        tabBarController?.tabBar.isHidden = true
        
        // Setup data source
        let currentFeedsSource = FeedsProfile.all
        feedsProfileNames = [String](currentFeedsSource.names)
        
        // Setup occasions table view
        feedsTableView.dataSource = self
        feedsTableView.delegate = self
        feedsTableView.separatorStyle = .none
        
        // Save selected feedProfile
        feedProfileSelectedFeedsIDs = [String](currentFeedsSource.selected.feedsIDs)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Configure UI
        configureAllButton()
        configureSaveButton()
    }
    
}
