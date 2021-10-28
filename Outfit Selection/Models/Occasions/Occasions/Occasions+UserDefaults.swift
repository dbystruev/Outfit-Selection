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
    /// Load selected occasion names from user defaults and updated Occasion.all
    static func restore() {
        // Get selected occasion names and make sure they are not empty
        let selectedIdsRestored = UserDefaults.selectedOccasionIDs
        guard !selectedIdsRestored.isEmpty else {
            debug("WARNING: Occasion list in user defaults is empty")
            return
        }
        
        var selectedOccasionsCount = 0
        
        for selectedRestoredId in selectedIdsRestored {
            guard let occasion = Occasions.byID[selectedRestoredId] else { continue }
            occasion.isSelected = true
            selectedOccasionsCount += 1
        }
        
        debug(
            "Occasions: \(selectedIdsRestored.count) loaded,",
            "\(selectedOccasionsCount) of \(Occasions.byID.count) selected"
        )
    }
    
    /// Save selected occasion names to user defaults
    static func saveSelectedOccasions() {
        UserDefaults.selectedOccasionIDs = selectedIDs
    }
}
