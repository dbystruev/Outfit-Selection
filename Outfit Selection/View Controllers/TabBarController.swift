//
//  TabBarController.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 24.02.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    
    override var selectedViewController: UIViewController? {
        get {
            super.selectedViewController
        }
        set {
            super.selectedViewController = newValue
            
            // Configure navigation item title to the currently selected view controller
            navigationItem.title = selectedViewController?.title
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Hide back button in navigation bar
        navigationItem.hidesBackButton = true
    }

}
