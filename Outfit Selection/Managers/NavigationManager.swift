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
class NavigationManager: AppDelegate {
    // MARK: - Public Type
    /// Enum with the  screens to navigate to
    public enum Screen {
        case outfit(items: Items)
        case feed
        case wishlist
        case profile
    }
    
    // MARK: - Static Properties
    static let shared = NavigationManager()
    
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
            
        case .outfit(let itemIDs):
            presentOutfitViewController(for: itemIDs, in: navigationController )
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
    ///   - itemIDs: itemIDs for present
    ///   - navigationController: the navigation controller
    public static func presentOutfitViewController(
        for itemIDs: Items,
        in navigationController: UINavigationController?
    ) {
 
        // Instantiate the tab bar controller
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = mainStoryboard.instantiateViewController(withIdentifier: "tabBarController")
        guard let tabBarController = controller as? UITabBarController else {
            debug("WARNING: Can't get Tab Bar Controller from the storyboard", mainStoryboard)
            return
        }
        
        // Switch to tab saved in previous version of tab bar controller
        tabBarController.selectedIndex = Globals.tabBarIndex.outfit
        
        // Suggest the wishlist tab with the largest number of items
        Wishlist.tabSuggested = Wishlist.largestKind
        
        // Load view models with the new images
        ItemManager.shared.loadImages(
            filteredBy: Gender.current,
            cornerLimit: 1
        ) { itemsLoaded, itemsTotal in
            
//            // Check for self availability
//            guard let self = self else {
//                debug("ERROR: self is not available")
//                return
//            }
            
            // If not all items loaded — update progress view and continue
            //self.updateProgressBar(current: itemsLoaded, total: itemsTotal, minValue: 0.5)
            
            guard itemsLoaded == itemsTotal else { return }
            
            // Save brand images for future selection change
//            BrandManager.shared.brandedImages = self.brandedImages
            
            DispatchQueue.main.async {
                // Unhide top navigation bar
                navigationController?.isNavigationBarHidden = false

                // Push to tab bar view controller
                navigationController?.pushViewController(tabBarController, animated: false)
            }
        }
    }
    
}
