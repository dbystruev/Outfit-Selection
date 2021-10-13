//
//  OccasionsViewController.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 09.09.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import UIKit

class OccasionsViewController: NextButtonViewController {
    
    // MARK: - Outlets
    /// Top right button to clear or select all brands
    @IBOutlet weak var allButton: SelectableButtonItem!
    
    /// The main table view with occasion list
    @IBOutlet weak var occasionsTableView: UITableView!
    
    // MARK: - Stored Properties
    var occasions: [Occasion] = Occasion.all.keys.sorted().compactMap { Occasion.all[$0] }
    
    // MARK: - Custom Methods
    /// Set top right button to clear or select all
    func configureAllButton() {
        allButton.isButtonSelected = Occasion.unselected.count < Occasion.selected.count
    }
    
    /// Set go button background color and enable / disable it depending on number of occasions selected
    func configureGoButton() {
        let occasionsSelected = Occasion.selected.count
        let isEnabled = 0 < occasionsSelected
        nextButton.backgroundColor = isEnabled
            ? Globals.Color.Button.enabled
            : Globals.Color.Button.disabled
        nextButton.isEnabled = isEnabled
    }
    
    // MARK: - Inherited Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup occasions table view
        occasionsTableView.dataSource = self
        occasionsTableView.delegate = self
        occasionsTableView.separatorStyle = .none
        
        // Remove onboarding view controllers
        let onboardingScreens = navigationController?.viewControllers.filter { $0 is OnboardingViewController }
        onboardingScreens?.reversed().forEach { $0.removeFromParent() }
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
