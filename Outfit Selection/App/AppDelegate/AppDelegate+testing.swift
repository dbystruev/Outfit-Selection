//
//  AppDelegate+Testing.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 29.11.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import Foundation

extension AppDelegate {
    /// Load occasion items and check that their subcategories match
    func testOccasionItems() {
        debug()
        
        // Dispatch group to wait for all requests to finish
        let group = DispatchGroup()
        
        // True if everything is valid
        var valid = true
        
        // Loading occasions
        group.enter()
        let startTime = Date()
        NetworkManager.shared.getOccasions { occasions in
            valid = valid && (0 < occasions?.count ?? 0)
            debug(occasions?.count, "occasions loaded in", Date().timeIntervalSince(startTime).asTime, "s")
            
            // Going through each occasion and checking items
            occasions?.sorted().forEach { occasion in
                // Go through each item in occasion and check if its subcategories match
                for (itemIDs, subcategoryIDs) in zip(occasion.corneredItemIDs, occasion.corneredSubcategoryIDs) {
                    valid = valid
                    && 0 < occasion.itemIDs.count
                    && occasion.itemIDs.count == occasion.subcategoryIDs.count
                    
                    group.enter()
                    let startTime = Date()
                    NetworkManager.shared.getItems(itemIDs) { items in
                        valid = valid && (0 < items?.count ?? 0)
                        
                        debug(
                            "\(occasion.title):", items?.count, "items loaded in",
                            Date().timeIntervalSince(startTime).asTime, "s"
                        )
                        
                        items?.forEach { item in
                            valid = valid && item.gender == occasion.gender
                            
                            guard item.isMatching(subcategoryIDs) else {
                                valid = false
                                debug("WARNING: \(item) is not matching \(subcategoryIDs)")
                                return
                            }
                        }
                        
                        // Leave dispatch group for get_items call
                        group.leave()
                    }
                }
                
                debug(
                    occasion.gender, occasion.title,
                    "has \(occasion.flatSubcategoryIDs.count) subcategories",
                    occasion.subcategoryIDs.map { $0.count },
                    "and \(occasion.flatItemIDs.count) items",
                    occasion.itemIDs.map { $0.count }
                )
            }
            
            // Leave dispatch group for get_occasions call
            group.leave()
        }
        
        group.notify(queue: DispatchQueue.global(qos: .background)) {
            debug("DEBUG: all occasion items were checked, are all valid: \(valid)")
        }
    }
}
