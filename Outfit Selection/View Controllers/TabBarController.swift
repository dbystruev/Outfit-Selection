//
//  TabBarController.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 24.02.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    /// Temporaty flag to debug TabBarController
    let debugging = false
    
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
            
            // Check if the gender has changed
            popToBrandsIfGenderChanged()
            
            // Check if the brands were changed
            popToProgressIfBrandsChanged()
        }
    }
    
    // MARK: - Custom Methods
    /// Pop to brands view controller if the user has changed the gender
    func popToBrandsIfGenderChanged() {
        if debugging {
            debug("DEBUG: Enter")
        }
        
        // Find profile view controller and its stored gender
        guard let newGender = findViewController(ofType: ProfileViewController.self)?.shownGender else {
            debug("WARNING: No profile view controller, view controllers =", viewControllers?.count, "children =", viewControllers?.compactMap{
                ($0 as? UINavigationController)?.viewControllers.count
            })
            return
        }
        
        // Don't pop if there is no change in gender
        guard Gender.current != newGender else {
            if debugging {
                debug("DEBUG: No gender change")
            }
            return
        }
        
        // Pop to brands view controller — don't change Gender.current as it uses it to decide to clear items and wish lists
        guard let brandsViewController = navigationController?.findViewController(ofType: BrandsViewController.self) else {
            debug("WARNING: Can't find brands view controller")
            return
        }
        
        brandsViewController.gender = newGender
        navigationController?.popToViewController(brandsViewController, animated: true)
        
        if debugging {
            debug("DEBUG: Leave")
        }
    }
    
    /// Pop to progress view controller if the user has changed the selection of brands
    func popToProgressIfBrandsChanged() {
        if debugging {
            debug("DEBUG: Enter")
        }
        
        // Don't pop if there is no change in brands selection
        guard BrandManager.shared.selectedBrands != selectedBrands else {
            if debugging {
                debug("DEBUG: Brands have not changed")
            }
            return
        }
        
        // Save currently selected index
        navigationController?.findViewController(ofType: ProgressViewController.self)?.selectedTabBarIndex = selectedIndex
        
        // Pop to previous (progress) view controller
        navigationController?.popViewController(animated: true)
        
        if debugging {
            debug("DEBUG: Leave")
        }
    }
    
    // MARK: - Inherited Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set tab bar icon colors
        UITabBar.appearance().tintColor = #colorLiteral(red: 66 / 255, green: 66 / 255, blue: 66 / 255, alpha: 1)
        UITabBar.appearance().unselectedItemTintColor = #colorLiteral(red: 66 / 255, green: 66 / 255, blue: 66 / 255, alpha: 0.5)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide navigation bar
        navigationController?.isNavigationBarHidden = true
    }
}
