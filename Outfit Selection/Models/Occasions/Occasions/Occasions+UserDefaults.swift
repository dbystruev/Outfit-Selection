//
//  Occasions+UserDefaults.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 28.10.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import Foundation

// MARK: - UserDefaults
extension Occasions {
    // MARK: - Static Methods
    /// Load selected occasion IDs from user defaults and update selected status
    static func restoreSelectedOccasions() {
        // Get selected occasion names and make sure they are not empty
        let restoredTitles = UserDefaults.selectedOccasionTitles
        if restoredTitles.isEmpty {
            debug("WARNING: The list of occasion titles in user defaults is empty")
        }
        
        for title in restoredTitles {
            Occasions.select(title: title, shouldSelect: true, permanent: false)
        }
        
        debug(
            "Occasions: \(restoredTitles.count) restored,",
            "\(Occasions.selected.titles.count) / \(Occasions.selected.count) of",
            "\(Occasions.titles.count) / \(Occasions.count) selected"
        )
    }
    
    /// Save selected occasion names to user defaults
    static func saveSelectedOccasions() {
        // Save occasion IDs for all genders
        UserDefaults.selectedOccasionTitles = [String](selected.titles)
    }
}
