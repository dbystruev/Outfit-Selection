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
    
    // MARK: - Computed Properties
    /// True if brand selection has changed
    var haveBrandsChanged: Bool {
        BrandManager.shared.selectedBrands != selectedBrands
    }
    
    /// True if gender has been changed by the user
    var hasGenderChanged: Bool {
        // Find profile view controller and its stored gender
        Gender.current != findViewController(ofType: ProfileViewController.self)?.shownGender
    }
    
    // MARK: - Inherited Properties
    override var selectedViewController: UIViewController? {
        get { super.selectedViewController }
        set {
            // Switch the tab to the new view controller
            super.selectedViewController = newValue
            
            // Don't do anything if there are no change in brands or gender
            guard haveBrandsChanged || hasGenderChanged else { return }
            
            // Start reloading the items
            NetworkManager.shared.reloadItems(for: Gender.current) { _ in }
            
            // Only go to progress if we changed to outfit view contorller
            guard newValue is OutfitViewController else { return }
            
            // Pop to progress view controller
            popToProgress()
        }
    }
    
    // MARK: - Custom Methods
    /// Pop to progress view controller without conditions
    func popToProgress() {
        // Save currently selected index
        navigationController?.findViewController(ofType: ProgressViewController.self)?.selectedTabBarIndex = selectedIndex
        
        // Pop to previous (progress) view controller
        navigationController?.popViewController(animated: true)
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
