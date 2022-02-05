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
    
    // MARK: - Methods
    /// - Parameters:
    ///   - items: Items for send ViewController
    func goToOutfitViewController(items: Items) {
        
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
        
        // Find tabBar controller in navigation controller
        guard let tabBar = navigationController.findViewController(ofType: UITabBarController.self) else {
            debug("TabBar controller is not available")
            return
        }
        
        // Find outfit view controller in tabBar
        guard let outfitViewController = tabBar.findViewController(ofType: OutfitViewController.self) else {
            debug("Outfit view controller is not available")
            return
        }
        
        // The set items for to show
        outfitViewController.itemsToShow = items
        
        debug(items)
        debug(outfitViewController.itemsToShow)
        
        // Show Navigation Controller
        navigationController.popViewController(animated: false)
        
    }
}
