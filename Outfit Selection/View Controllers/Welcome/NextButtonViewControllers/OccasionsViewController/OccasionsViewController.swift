//
//  OccasionsViewController.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 09.09.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import UIKit

/// Occasion selection view controller
class OccasionsViewController: NextButtonViewController {
    
    // MARK: - Outlets
    /// Top right button to clear or select all brands
    @IBOutlet weak var allButton: SelectableButtonItem!
    
    /// The main table view with occasion list
    @IBOutlet weak var occasionsTableView: UITableView!
    
    // MARK: - Stored Properties
    /// Dictionary of occasion labels with occasion names as keys
    var occasionLabels: [String: [String]] = [:]
    
    /// Array of occasion names
    var occasionNames: [String] = []
    
    // MARK: - Computed Properties
    ///  All occasion titles for current gender sorted
    var occasionTitles: [String] {
        Occasions.currentGender.titles.sorted()
    }
    
    // MARK: - Custom Methods
    /// Set top right button to clear or select all
    func configureAllButton() {
        let occasions = Occasions.currentGender
        allButton.isButtonSelected = occasions.unselected.count < occasions.selected.count
    }
    
    /// Set go button background color and enable / disable it depending on number of occasions selected
    func configureGoButton() {
        let occasionsSelected = Occasions.selected.currentGender.count
        let isEnabled = 0 < occasionsSelected
        nextButton?.backgroundColor = isEnabled
        ? Globals.Color.Button.enabled
        : Globals.Color.Button.disabled
        nextButton?.isEnabled = isEnabled
    }
    
    // MARK: - Inherited Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // If viewControllew called from profile
        if isEditing {
            // Hide back button
            navigationItem.hidesBackButton = isEditing
            // Set new backButton into leftBarButtonItem
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel"~, style: .plain, target: self, action: #selector(cancelButtonTap))
            
            // Change title nexButton
            nextButton?.setTitle("Save"~, for: .normal)
            
            // Hide tabBar
            tabBarController?.tabBar.isHidden = true
        }
        
        // Setup data source
        let currentGenderOccasions = Occasions.currentGender
        occasionNames = currentGenderOccasions.names.sorted()
        occasionNames.forEach { name in
            occasionLabels[name] = currentGenderOccasions.with(name: name).labels.sorted()
        }
        
        // Setup occasions table view
        occasionsTableView.dataSource = self
        occasionsTableView.delegate = self
        occasionsTableView.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Unhide top navigation bar
        navigationController?.isNavigationBarHidden = false
        
        // Configure UI
        configureAllButton()
        configureGoButton()
    }
}
