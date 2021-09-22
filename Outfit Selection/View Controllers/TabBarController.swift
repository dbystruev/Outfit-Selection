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
    override var selectedViewController: UIViewController? {
        get { super.selectedViewController }
        set {
            // Switch the tab to the new view controller
            super.selectedViewController = newValue
            
            // Check if the gender has changed
            popToProgressIfGenderHasChanged()
            
            // Check if the brands were changed
            popToProgressIfBrandsHaveChanged()
        }
    }
    
    // MARK: - Custom Methods
    /// Reload items and pop to progress view controller without conditions
    func popToProgress() {
        // Reload items with new brands or gender
        NetworkManager.shared.reloadItems(for: Gender.current) { _ in }
        
        // Save currently selected index
        navigationController?.findViewController(ofType: ProgressViewController.self)?.selectedTabBarIndex = selectedIndex
        
        // Pop to previous (progress) view controller
        navigationController?.popViewController(animated: true)
    }
    
    /// Pop to progress view controller if the user has changed the selection of brands
    func popToProgressIfBrandsHaveChanged() {
        // Don't pop if there is no change in brands selection
        guard BrandManager.shared.selectedBrands != selectedBrands else { return }
        
        // Pop to progress view controller and reload items with new brands selection
        popToProgress()
    }
    
    /// Pop to progress view controller if the user has changed the gender
    func popToProgressIfGenderHasChanged() {
        // Find profile view controller and its stored gender
        guard let newGender = findViewController(ofType: ProfileViewController.self)?.shownGender else {
//            debug("WARNING: No profile view controller, view controllers =", viewControllers?.count, "children =", viewControllers?.compactMap{
//                ($0 as? UINavigationController)?.viewControllers.count
//            })
            return
        }
        
        // Don't pop if there is no change in gender
        guard Gender.current != newGender else { return }
        
        // Pop to progress view controller and reload items with new gender
        popToProgress()
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
