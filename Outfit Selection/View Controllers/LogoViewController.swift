//
//  LogoViewController.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 26.01.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import UIKit

class LogoViewController: UIViewController {
    // MARK: - Outlets
    /// Image view with Get Outfit logo
    @IBOutlet weak var logoImageView: UIImageView!
    
    /// Label with text "Get Outfit is a personalised styling platform"
    @IBOutlet weak var descriptionLabel: UILabel!
    
    // MARK: - Inherited Methods
    /// Hides toolbar after the controller's view is loaded into memory
    override func viewDidLoad() {
        super.viewDidLoad()

        // Hide toolbar at the bottom
        navigationController?.isToolbarHidden = true
    }
    
    /// Segue to Gender View Controller after the view was added to a view hierarchy
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Segue to Gender View Controller
        performSegue(withIdentifier: "GenderViewControllerSegue", sender: nil)
    }
    
    /// Hides navigation bar before the view is added to a view hierarchy
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide navigation bar on top
        navigationController?.navigationBar.isHidden = true
    }
}
