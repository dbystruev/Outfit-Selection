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
/// Notification name feedProfileChanged
    let nameNotification = Globals.Notification.name.feedProfileChanged
    /// The set of brand tags previously selected by the user
    var selectedBrands = BrandManager.shared.selectedBrands
    
    // MARK: - Computed Properties
    /// True if brand selection has changed
    var haveBrandsChanged: Bool {
        BrandManager.shared.selectedBrands != selectedBrands
    }
    
    /// True if gender has been changed by the user
    var hasGenderChanged: Bool {
        // Find profile view controller and its stored gender
        guard let shownGender = findViewController(ofType: ProfileViewController.self)?.shownGender else { return false }
        return Gender.current != shownGender
    }
    
    // MARK: - Inherited Properties
    override var selectedViewController: UIViewController? {
        get { super.selectedViewController }
        set {
            // Switch the tab to the new view controller
            super.selectedViewController = newValue
            
            // Check for brands / gender change and reload
            reloadItems()
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
    
    /// Reload the items if brands selection or gender have changed
    func reloadItems() {
        
        // Reload section with brand from FeedCollectionViewController
        if self.selectedIndex == Globals.TabBar.index.feed {
            guard let feedCollectionViewController = findViewController(ofType: FeedCollectionViewController.self) else { return }
            feedCollectionViewController.feedCollectionView?.reloadSections(IndexSet([0]))
        }
        
        // Don't do anything if there are no changes in brands or gender
        guard hasGenderChanged else { return }
        
        // Update all occasions with given gender
        Occasions.updateWith(gender: Gender.current)
        
        // Start reloading the items
        NetworkManager.shared.reloadItems(for: Gender.current) { _ in }
        
        // Pop to progress view controller
        popToProgress()
    }
    
    @objc func popToProgressReloadItems() {
        // Start reloading the items
        NetworkManager.shared.reloadItems(for: Gender.current) { _ in }
        popToProgress()
    }
    
    // MARK: - Inherited Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set tab bar icon colors
        UITabBar.appearance().tintColor = #colorLiteral(red: 66 / 255, green: 66 / 255, blue: 66 / 255, alpha: 1)
        UITabBar.appearance().unselectedItemTintColor = #colorLiteral(red: 66 / 255, green: 66 / 255, blue: 66 / 255, alpha: 0.5)
        
        if !(User.current.debugmode ?? false) {
            // Remove chat from viewControllers
            self.viewControllers?.remove(at:Globals.TabBar.index.chat)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide navigation bar
        navigationController?.isNavigationBarHidden = true
        
        // Start observer changed feedProfile
//        if User.current.debugmode {
            Globals.Notification.notificationCenter.addObserver(
                self,
                selector: #selector(popToProgressReloadItems),
                name: Notification.Name(nameNotification),
                object: nil
            )
//        }
    }
}
