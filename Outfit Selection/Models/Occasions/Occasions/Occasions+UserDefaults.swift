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
        let selectedIDsRestored = UserDefaults.selectedOccasionIDs
        guard !selectedIDsRestored.isEmpty else {
            debug("WARNING: Occasion list in user defaults is empty")
            return
        }
        
        var selectedOccasionsCount = 0
        
        for selectedRestoredID in selectedIDsRestored {
            guard let occasion = Occasions.byID[selectedRestoredID] else { continue }
            occasion.isSelected = true
            selectedOccasionsCount += 1
        }
        
        debug(
            "Occasions: \(selectedIDsRestored.count) loaded,",
            "\(selectedOccasionsCount) of \(Occasions.byID.count) selected"
        )
    }
    
    /// Save selected occasion names to user defaults
    static func saveSelectedOccasions() {
        // Get occasion IDs for other genders
        let storedOccasionIDs = UserDefaults.selectedOccasionIDs.filter {
            Occasions.byID[$0]?.gender != Gender.current
        }
        
        // Save occasion IDs for all genders
        UserDefaults.selectedOccasionIDs = (selectedIDs + storedOccasionIDs).unique
    }
}
