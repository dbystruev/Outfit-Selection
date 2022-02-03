//
//  AppDelegate+universalLinks.swift
//  Outfit Selection
//
//  Created by Evgeniy Goncharov on 03.02.2022.
//  Copyright © 2022 Denis Bystruev. All rights reserved.
//

import Foundation
extension AppDelegate {
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
}
