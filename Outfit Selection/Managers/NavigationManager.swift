//
//  NavigationManager.swift
//  Outfit Selection
//
//  Created by Evgeniy Goncharov on 04.02.2022.
//  Copyright © 2022 Denis Bystruev. All rights reserved.
//

import UIKit

// Methods used for navigating between app's screens
class NavigationManager {
    
    // MARK: - Public Type
    /// Enum with the  screens to navigate to
    public enum Screen {
        case outfit(items: Items = [], hideBackButton: Bool = true)
        case feed
        case wishlist
        case profile
    }
    
    // MARK: - Static Properties
    static let shared = NavigationManager()
    
    // MARK: - Private Methods
    private init() {}
    
    /// Unhide navigation bar and push view controller into navigation controller
    /// - Parameters:
    ///   - navigationController: navigation controller to push view controller into
    ///   - viewController: view controller to push into navigation controller, for example tabBarViewController
    private func pushViewController (
        navigationController: UINavigationController,
        viewController: UIViewController,
        animated: Bool = true
    ) {
        // Unhide top navigation bar
        navigationController.isNavigationBarHidden = false
        
        // Push to navigation controller
        navigationController.pushViewController(viewController, animated: animated)
    }
    
    /// Push view controllers with given identities from given storyboard into given navigation controller
    /// - Parameters:
    ///   - name: storyboard name
    ///   - identity: array with identities of view controllers
    ///   - navigationController: navigation controller to push view controller into
    ///   - animated: true if should be animated
    private func pushViewController(
        name: String,
        identities: [String],
        navigationController: UINavigationController,
        animated: Bool
    ) {
        // Get storyboard with given name
        let storyboard = UIStoryboard(name: name, bundle: nil)
        
        for identity in identities {
            // Find view controller with given identity
            let controller = storyboard.instantiateViewController(withIdentifier: identity)
            
            // Push view controller to the navigation controller
            navigationController.pushViewController(controller, animated: animated)
        }
    }
    
    // MARK: - Public Static Methods
    /// Navigate to a given screen
    /// - Parameter screen: a screen to navigate to
    public static func navigate(to screen: Screen) {
        
        // Get app delegate — should be available
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            debug("ERROR: App delegate is not found")
            return
        }
        
        // Get root view controller
        guard let rootViewController = appDelegate.window?.rootViewController else {
            debug("ERROR: Root view controller is not available")
            return
        }
        
        // Get navigation view controller
        guard let navigationController = rootViewController as? UINavigationController else {
            debug("ERROR: Root view controller is not navigation controller")
            return
        }
        
        switch screen {
        case .outfit(let items, let hideBackButton):
            // Find tab bar controller
            guard let tabBarController = navigationController.findViewController(ofType: TabBarController.self) else {
                debug("INFO: Tab Bar Controller is not available")
                
                // If tab bar controller is not available go to
                presentOutfitViewController(for: items, in: navigationController)
                return
            }
            
            // It will be start when items is not empty and tabBar is not found
            if items.isEmpty {
                presentOutfitViewController(in: navigationController)
            } else {
                presentOutfitViewControllerWithTabBar(items, navigationController, tabBarController, hideBackButton)
            }
            
        case .feed:
            debug("feed")
            
        case .wishlist:
            // Find tab bar controller
            guard let tabBarController = navigationController.findViewController(ofType: TabBarController.self) else {
                debug("INFO: Tab Bar Controller is not available")
                return
            }
            
//            // Find outfitViewController
//            guard let outfitViewController = tabBarController.findViewController(ofType: OutfitViewController.self) else {
//                debug("INFO: OutfitViewController is not available")
//                return
//            }
//
            // Find wishlistViewController
            guard let wishlistViewController = tabBarController.findViewController(ofType: WishlistViewController.self) else {
                debug("INFO: WishlistViewController not available")
                return
            }
            
            debug(wishlistViewController)

            // Change tabbar selected index
            tabBarController.selectedIndex = Globals.TabBar.index.wishlist
            
//            tabBarController.transition(
//                from: outfitViewController,
//                to: wishlistViewController,
//                duration: 0.3,
//                options: [.transitionCrossDissolve]
//            ) {} completion: { bool in
//                // Is waiting when bool will be become true
//                guard bool else { return }
//
//                // Change tabbar selected index
//                tabBarController.selectedIndex = Globals.TabBar.index.wishlist
//            }

            
        case .profile:
            debug("profile")
        }
    }
    
    /// Present  tabBarController with index
    /// - Parameters:
    ///   - Items: Items for present
    ///   - navigationController: the navigation controller
    ///   - tabBarController: the tab bar controller
    ///   - hideBackButton: hide back bar button item if true, show if false
    public static func presentOutfitViewControllerWithTabBar(
        _ items: Items,
        _ navigationController: UINavigationController,
        _ tabBarController: UITabBarController,
        _ hideBackButton: Bool
    ) {
        // Get tab bat index
        let indexTabBar = Globals.TabBar.index.outfit
        
        // Get the list of view controllers from tab bar
        guard let viewControllers = tabBarController.viewControllers else {
            debug("ERROR: There are no view controllers in tab bar")
            return
        }
        
        // Get navigation controller from tab bar with index
        guard let navigationController = viewControllers[indexTabBar] as? UINavigationController else {
            debug("ERROR: Navigation controller is not available")
            return
        }
        
        // Get outfit view controller
        guard let outfitViewController = navigationController.findViewController(ofType: OutfitViewController.self) else {
            debug("ERROR: OutfitViewController controller is not available")
            return
        }
        
        // Clear all scroll views for new items
        outfitViewController.scrollViews.clear()
        
        // Set items to show scrollViews
        outfitViewController.itemsToShow = items
        
        // Set back button status
        outfitViewController.shouldHideBackBarButtonItem = hideBackButton
        
        // Check items checkItemsToShow and download it if
        outfitViewController.checkItemsToShow()
        
        // Check state tab bar controller
        guard tabBarController.selectedIndex != indexTabBar else { return }
        tabBarController.selectedIndex = indexTabBar
    }
    
    /// Present  viewController with Instantiate tabBarController
    /// - Parameters:
    ///   - itemIDs: itemIDs for present
    ///   - navigationController: the navigation controller
    public static func presentOutfitViewController (
        for items: Items = [],
        in navigationController: UINavigationController
    ) {
        // Initiate progress view controller
        let progressViewController = ProgressViewController.default
        
        // Initiate barandes
        let brandedImages = BrandManager.shared.brandedImages
        
        // Hide navigation bar on top (needed when returning from profile view controller)
        navigationController.isNavigationBarHidden = true
        
        // Initiate progress with 0
        progressViewController?.progressView.progress = 0
        
        // Instantiate the tab bar controller
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = mainStoryboard.instantiateViewController(withIdentifier: "tabBarController")
        guard let tabBarController = controller as? UITabBarController else {
            debug("ERROR: Can't get Tab Bar Controller from the storyboard", mainStoryboard)
            return
        }
        
        // Switch to tab saved in previous version of tab bar controller
        tabBarController.selectedIndex = Globals.TabBar.index.outfit
        
        // Find outfit view controller in tab bar hierarchy
        guard let outfitViewController = tabBarController.findViewController(ofType: OutfitViewController.self) else {
            debug("ERROR: OutfitViewController not found")
            return
        }
        
        //  Get viewModels IDs
        let viewModelsItemIDs = Set(ItemManager.shared.viewModels.items.IDs)
        guard items.isEmpty || !viewModelsItemIDs.isSubset(of: items.IDs) else {
            
            // Set items to show
            outfitViewController.itemsToShow = items
            
            // Push ViewControllers
            let identityIDs = [
                "BrandsViewController",
                "OccasionsViewController",
                "ProgressViewController"
            ]
            NavigationManager.shared.pushViewController(
                name: "Welcome",
                identities: identityIDs,
                navigationController: navigationController,
                animated: false
            )
            
            // Push NavigationController with tabBar
            NavigationManager.shared.pushViewController (
                navigationController: navigationController,
                viewController: tabBarController,
                animated: false
            )
            
            return
        }
        
        // Suggest the wishlist tab with the largest number of items
        Wishlist.tabSuggested = Wishlist.largestKind
        
        // Load view models with the new images
        ItemManager.shared.loadImages(
            filteredBy: Gender.current,
            cornerLimit: 1
        ) { [weak progressViewController] itemsLoaded, itemsTotal in
            
            // If not all items loaded — update progress view and continue
            progressViewController?.updateProgressBar(current: itemsLoaded, total: itemsTotal, minValue: 0.5)
            guard itemsLoaded == itemsTotal else { return }
            
            // Save brand images for future selection change
            BrandManager.shared.brandedImages = brandedImages
            
            DispatchQueue.main.async {
                NavigationManager.shared.pushViewController (
                    navigationController: navigationController,
                    viewController: tabBarController
                )
            }
        }
    }
}
