//
//  AppDelegate+universalLinks.swift
//  Outfit Selection
//
//  Created by Evgeniy Goncharov on 03.02.2022.
//  Copyright © 2022 Denis Bystruev. All rights reserved.
//

import UIKit

extension AppDelegate {
    // MARK: - Methods
    /// Checker valid items
    /// - Parameter itemIDs: String array with itemIDs
    /// - Returns: [String] with valid itemIDs
    func checkItemIDs(itemIDs: [String]) -> Any {
        var checkedItemIDs: [String] = []
        NetworkManager.shared.getItems(itemIDs, completion: { checkitemIDs in
            checkedItemIDs = checkitemIDs!.IDs
        })
        return checkedItemIDs.isEmpty ? "Empty" : checkedItemIDs
    }
    
    /// Pars, drop and separeted IDs
    /// - Parameter URL: the url with IDs for convert to array
    /// - Parameter String: for separat symbol, default = ","
    /// - Returns: [String]
    func parsItemIDs(url: URL, separat: String = ",") -> Any {
        let cutLink =  String(describing: url)
            .replacingOccurrences(
                of: "\(String(describing: url).dropExtension).",
                with: ""
            )
            .replacingOccurrences(
                of: "(",
                with: ""
            )
            .replacingOccurrences(
                of: ")",
                with: ""
            )
            .replacingOccurrences(
                of: "^[^0-9]*",
                with: "",
                options: [.caseInsensitive, .regularExpression]
            )
            .components(separatedBy: ",")
        
        return cutLink.isEmpty ? "Empty" : cutLink
    }
    
    /// Pars, drop and separeted IDs
    /// - Parameter VC:
    func findVC() {
        
        // Get app delegate — should be available
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            debug( "App delegate is not found")
            return
        }
        
        // Get root view controller
        guard let rootViewController = appDelegate.window?.rootViewController else {
            debug( "Root view controller is not available")
            return
        }
        
        // Find tabBar view controller in Root view controller
        guard let tabBar = rootViewController as? UITabBarController else {
            debug( "TabBar is not found")
            return
        }
        
        // Find outfit view controller in navigation
        guard let outfitViewController = tabBar.findViewController(ofType: OutfitViewController.self) else {
            debug( "OutfitViewController is not found")
            return
        }
        
        debug("Congratulation: Found \(outfitViewController)"  )
    }
}
