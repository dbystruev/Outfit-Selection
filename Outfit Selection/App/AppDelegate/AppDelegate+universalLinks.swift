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
        var checkedItemIDs: Items = []
        NetworkManager.shared.getItems(itemIDs, completion: { checkitemIDs in
            checkedItemIDs = checkitemIDs!
            
        })
        return checkedItemIDs.isEmpty ? "Empty" : checkedItemIDs
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
    
    /// Checker universal link
    /// - Parameter URL: the url universal link
    func checkUniversalLink(url: URL){
        
        // Try to get parametr from URL
        guard let id = url.getParametrs!["id"]?.dropExtension else {
            debug("ERROR: url without id")
            return }
        
        // Parser items from url, remove dot and replace "(",")"
        guard let items = parserItemIDs(url: url) as? [String] else {
            debug("ERROR: array is empty")
            return }
        
        // Check items for valid with network manager
        guard let checkedItemIDs = checkItemIDs(itemIDs: items) as? Items else {
            debug("ERROR: ids is not correct")
            return }
        
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
}
