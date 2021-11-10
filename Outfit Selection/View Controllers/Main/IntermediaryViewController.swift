//
//  IntermediaryViewController.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 01.03.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import SafariServices

class IntermediaryViewController: LoggingViewController {
    // MARK: - Outlets
    @IBOutlet weak var takingYouLabel: UILabel!
    
    // MARK: - Properties
    /// Item url to take user to
    var url: URL?
    
    // MARK: - Inherited Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Hide navigation and tab bars
        navigationController?.isNavigationBarHidden = true
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        takingYouLabel.text = url == nil
        ? "Taking you back to GET OUTFIT..."~
        : "Now taking you to FARFETCH..."~
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Open Safari view controller with given URL or pop back
        guard let url = url else {
            navigationController?.popViewController(animated: true)
            
            // Show navigation and tab bars
            navigationController?.isNavigationBarHidden = false
            tabBarController?.tabBar.isHidden = false
            
            return
        }
        
        let config = SFSafariViewController.Configuration()
        config.barCollapsingEnabled = false
        
        let controller = SFSafariViewController(url: url, configuration: config)
        present(controller, animated: true)
        
        // Clear url to pop back after we return
        self.url = nil
    }
    
}
