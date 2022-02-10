//
//  NavigationManager.swift
//  Outfit Selection
//
//  Created by Evgeniy Goncharov on 04.02.2022.
//  Copyright © 2022 Denis Bystruev. All rights reserved.
//

import Foundation
import UIKit

// Methods used for navigating between app's screens
class NavigationManager: LoggingViewController {
    // MARK: - Public Type
    /// Enum with the  screens to navigate to
    public enum Screen {
        case outfit(items: Items = [])
        case feed
        case wishlist
        case profile
    }
    
    // MARK: - Static Properties
    static let shared = NavigationManager()
    static weak var `default`: ProgressViewController?
    
    // MARK: - Public Static Methods
    /// Navigate to a given screen
    /// - Parameter screen: a screen to navigate to
    public static func navigate(to screen: Screen) {
        
        // Get app delegate — should be available
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            debug("App delegate is not found")
            return
        }
        
        // Get root view controller
        guard let rootViewController = appDelegate.window?.rootViewController else {
            debug("Root view controller is not available")
            return
        }
        
        // Get navigation view controller
        guard let navigationController = rootViewController as? UINavigationController else {
            debug("Navigation controller is not available")
            return
        }
        
        switch screen {
            
        case .outfit(let items):
            
            // Find Tab Bar controller
            guard let tabBarController = navigationController.findViewController(ofType: TabBarController.self) else {
                debug("Tab Bar Controller is not available")
                
                // If tab bar controller is not available go to
                presentOutfitViewController(for: items, in: navigationController )
                return
            }
            
            if items.isEmpty {
                presentOutfitViewController(for: [], in: navigationController)
            } else {
                presentOutfitViewControllerWithTabBar(
                    items: items,
                    navigationController: navigationController,
                    tabBarController: tabBarController
                )
            }
            
        case .feed:
            debug("feed")
        case .wishlist:
            debug("wishlist")
        case .profile:
            debug("profile")
        }
        
    }
    
    /// Present  tabBarController with index
    /// - Parameters:
    ///   - Items: Items for present
    ///   - navigationController: the navigation controller
    ///   - tabBarController: the tab bar controller
    public static func presentOutfitViewControllerWithTabBar(
        items: Items,
        navigationController: UINavigationController,
        tabBarController: UITabBarController
    ) {
        // Get tab bat index
        let indexTabBar = Globals.tabBar.index.outfit
        
        // Get the list of view controllers from tab bar
        guard let viewControllers = tabBarController.viewControllers else {
            debug("There are no view controllers in tab bar")
            return
        }
        
        // Get navigation controller from tab bar with index
        guard let navigationController = viewControllers[indexTabBar] as? UINavigationController else {
            debug("Navigation controller is not available")
            return
        }
        
        // Get outfit view controller
        guard let outfitViewController = navigationController.findViewController(ofType: OutfitViewController.self) else {
            debug("OutfitViewController controller is not available")
            return
        }
        
        // Check state tab bar controller
        if tabBarController.selectedIndex == indexTabBar {
            debug("OutfitViewController is showing now")
            
            // Set items to show
            outfitViewController.itemsToShow = items
            
            //Check items to show and download images
            outfitViewController.checkItemsToShow()
            
        } else {
            debug("OutfitViewController is not showing now, index:", tabBarController.selectedIndex)
            
            outfitViewController.itemsToShow = items
            
            // Set tab bar index
            tabBarController.selectedIndex = indexTabBar
            
        }
    }
    
    // TODO: Make completly function
    /// Present  viewController with Instantiate tabBarController
    /// - Parameters:
    ///   - itemIDs: itemIDs for present
    ///   - navigationController: the navigation controller
    public static func presentOutfitViewController (
        for items: Items,
        in navigationController: UINavigationController
    ) {

        let progressViewController = ProgressViewController.default
        
        // MARK: - Stored Properties
        /// The collection of brand images
        
        // Hide navigation bar on top (needed when returning from profile view controller)
        NavigationManager.shared.navigationController?.isNavigationBarHidden = true
        
        // Initiate progress with 0
        progressViewController?.progressView.progress = 0
        
        // Instantiate the tab bar controller
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = mainStoryboard.instantiateViewController(withIdentifier: "tabBarController")
        guard let tabBarController = controller as? UITabBarController else {
            debug("WARNING: Can't get Tab Bar Controller from the storyboard", mainStoryboard)
            return
        }
        
        // Switch to tab saved in previous version of tab bar controller
        tabBarController.selectedIndex = Globals.tabBar.index.outfit
        
        if !items.isEmpty {
            guard let outfitViewController = tabBarController.findViewController(ofType: OutfitViewController.self) else {
                debug("OutfitViewController not found")
                return
            }
            outfitViewController.itemsToShow = items
            outfitViewController.checkItemsToShow()
        }
        
        // Suggest the wishlist tab with the largest number of items
        Wishlist.tabSuggested = Wishlist.largestKind
        
        // Load view models with the new images
        ItemManager.shared.loadImages(
            filteredBy: Gender.current,
            cornerLimit: 1
        ) { itemsLoaded, itemsTotal in
            // Check for self availability
            //            guard let self = self else {
            //                debug("ERROR: self is not available")
            //                return
            //            }
            
            // If not all items loaded — update progress view and continue
            ProgressViewController.default?.updateProgressBar(current: itemsLoaded, total: itemsTotal, minValue: 0.5)
            guard itemsLoaded == itemsTotal else { return }
            
            // Save brand images for future selection change
            //BrandManager.shared.brandedImages = progressViewController!.brandedImages
            
            DispatchQueue.main.async {
                // Unhide top navigation bar
                navigationController.isNavigationBarHidden = false
                // Push to tab bar view controller
                navigationController.pushViewController(tabBarController, animated: true)
            }
        }
    }
}
