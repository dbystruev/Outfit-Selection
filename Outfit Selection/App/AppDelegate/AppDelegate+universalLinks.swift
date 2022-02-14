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
    func checkUniversalLink(continue userActivity: NSUserActivity){
        
        guard userActivity.activityType == NSUserActivityTypeBrowsingWeb,
            let url = userActivity.webpageURL else { return }
        
        // Try to get parametr from URL
        guard let id = url.getParameters["id"]?.dropExtension else {
            debug("ERROR: url without id")
            return }
        
        debug(url)
        
        // Parser items from url, remove dot and replace "(",")"
        guard let items = parserItemIDs(url: url) as? [String] else {
            debug("ERROR: array is empty")
            return }
        
        debug(items)
        
        ItemManager.shared.checkItemsByID(items) { item in
            guard let items = item else { return }
            
            // Check id and go to NavigationManager
            switch id {
            case "eq":
                debug("INFO: id", id, "items", items.IDs)
                
            case "in":
                debug(items.IDs)
                
                //  Get viewModels IDs
                let viewModelsItemIDs = Set(ItemManager.shared.viewModels.items.IDs)
                debug("ViewModels:", viewModelsItemIDs.count, "Items:", items.IDs.count, viewModelsItemIDs.intersection(items.IDs).count)
                
                
                // Download all images and add to viewModels
                ItemManager.shared.loadImagesFromItems(items: items) {
                    

                let viewModelsItemIDs = Set(ItemManager.shared.viewModels.items.IDs)
                debug("ViewModels:", viewModelsItemIDs.count, "Items:", items.IDs.count, viewModelsItemIDs.intersection(items.IDs).count)
                    
                    
                // Go to NavigationManager into outfit
                NavigationManager.navigate(to: .outfit(items: items))
                }
                
            default:
                debug("ERROR: id not found in this switch")
            }
        }
        
    }
    
    
    /// Parser, drop and separeted IDs
    /// - Parameter URL: the url with IDs for convert to array
    /// - Parameter String: for separat symbol, default = ","
    /// - Returns: [String]
    func parserItemIDs(url: URL, separator: String = ",") -> Any {
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
    
}
