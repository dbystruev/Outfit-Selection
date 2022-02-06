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
        guard let id = url.getParametrs!["id"]?.dropExtension else {
            debug("ERROR: url without id")
            return }
        
        // Parser items from url, remove dot and replace "(",")"
        guard let items = parserItemIDs(url: url) as? [String] else {
            debug("ERROR: array is empty")
            return }
        
        // Check items for valid with network manager
        guard let checkedItemIDs = ItemManager.shared.chekItemsByID(items) as? Items else {
            debug("ERROR: ids is not correct")
            return }
        
        // Check id and go to NavigationManager
        switch id {
        case "eq":
            
            debug("INFO: id: \(id), items: \(checkedItemIDs)")
            
        case "in":
            let navigation = NavigationManager()
            navigation.goToOutfitViewController(items: checkedItemIDs)
            
            debug("INFO: id: \(id), items: \(checkedItemIDs)")
            
        default:
            debug("ERROR: id not found in this switch")
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
