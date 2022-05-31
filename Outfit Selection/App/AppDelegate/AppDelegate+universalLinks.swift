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
    /// - Parameters:
    ///   - userActivity: the activity object containing the data associated with the task the user was performing
    func checkUniversalLink(continue userActivity: NSUserActivity) {
        debug(userActivity)
        guard userActivity.activityType == NSUserActivityTypeBrowsingWeb, let url = userActivity.webpageURL else {
            debug("INFO: webpageURL not found")
            return
        }
        
        // Get first parametеr "id" from URL
        guard let id = url.getParameters["id"]?.components(separatedBy: ".").first else {
            debug("ERROR: url without id")
            return
        }
        
        // Get last parametеr "id" from URL
        guard let itemsString = url.getParameters["id"]?.components(separatedBy: ".").last else {
            debug("ERROR: url without id")
            return
        }
        
        // Parser items from url, remove dot and replace "(",")"
        guard let items = parserItemIDs(string: itemsString) as? [String] else {
            debug("ERROR: array is empty")
            return
        }
        
        ItemManager.shared.checkItemsByID(items) { [self] items in
            guard let items = items else { return }
            // Check id and go to NavigationManager
            switch id {
            case "eq":
                self.userActivity = nil
                NavigationManager.navigate(to: .wishlist(item: items.first))
                
            case "in":
                self.userActivity = nil
                // Try to get a name parametеr from URL
                guard let name = url.getParameters["name"]?.components(separatedBy: ".").last else {
                    navigate(items: items)
                    return
                }
                navigate(items: items, with: name)
                
            default:
                debug("ERROR: id", id, "not found in this switch")
            }
            
            // Set deafult setting
            if !UserDefaults.hasSeenAppIntroduction || !UserDefaults.hasAnswerQuestions {
                self.configureSettings()
                debug("Configure Settings")
            }
        }
    }
    
    // MARK: - Private Methods
    /// Navigate to NavigationManager with parameter name or not
    /// - Parameters:
    ///   - items: exctracted items from URL
    ///   - name: name parameter from URL
    private func navigate(items: Items, with name: String? = nil) {
        // Download all images and add to viewModels
        ItemManager.shared.loadImagesFromItems(items: items) {
            if name != nil {
                guard let name = name else { return }
                // Go to NavigationManager into wishlistCollections
                NavigationManager.navigate(to: .wishlistCollections(items: items, name: name))
                
            } else {
                // Go to NavigationManager into outfit
                NavigationManager.navigate(to: .outfit(items: items))
            }
        }
    }
    
    /// Parser, drop and separeted IDs
    /// - Parameters:
    ///   - url: the url with IDs for convert to array
    ///   - separator: for separat symbol, default = ","
    /// - Returns: [String]
    private func parserItemIDs(string: String, separator: String = ",") -> Any {
        let cutLink = string
            .replacingOccurrences(
                of: "(",
                with: ""
            )
            .replacingOccurrences(
                of: ")",
                with: ""
            )
            .replacingOccurrences(
                of: "^[^a-zA-Z0-9]*",
                with: "",
                options: [.caseInsensitive, .regularExpression]
            )
            .components(separatedBy: separator)
        return cutLink.isEmpty ? "Empty" : cutLink
    }
    
}
