//
//  TabBarController.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 24.02.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    // MARK: - Stored Properties
    /// The set of brand tags previously selected by the user
    let selectedBrands = BrandManager.shared.selectedBrands
    
    // MARK: - Inherited Properties
    /// The view controller associated with the currently selected tab item
    override var selectedViewController: UIViewController? {
        get {
            super.selectedViewController
        }
        set {
            // Switch the tab to the new view controller
            super.selectedViewController = newValue
            
            // If the user has selected differnt brands go back to progress view controller
            guard BrandManager.shared.selectedBrands == selectedBrands else {
                // Saved currently selected index
                navigationController?.findViewController(ofType: ProgressViewController.self)?.selectedTabBarIndex = selectedIndex
                
                // Pop to previous (progress) view controller
                navigationController?.popViewController(animated: true)
                
                return
            }
            
            // Configure navigation item title to the currently selected view controller
            let title = selectedViewController?.title ?? ""
            if title.isEmpty {
                navigationController?.isNavigationBarHidden = true
            } else {
                navigationController?.isNavigationBarHidden = false
                navigationItem.title = title
            }
            
            // Configure navigation item right bar button items to the currently selected view controller
            navigationItem.rightBarButtonItems = selectedViewController?.navigationItem.rightBarButtonItems
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Hide back button in navigation bar
        navigationItem.hidesBackButton = true
        
        // Set tab bar icon colors
        UITabBar.appearance().tintColor = #colorLiteral(red: 66 / 255, green: 66 / 255, blue: 66 / 255, alpha: 1)
        UITabBar.appearance().unselectedItemTintColor = #colorLiteral(red: 66 / 255, green: 66 / 255, blue: 66 / 255, alpha: 0.5)
    }

}
