//
//  Feeds+UserDefaults.swift
//  Outfit Selection
//
//  Created by Evgeniy Goncharov on 05.05.2022.
//  Copyright © 2022 Denis Bystruev. All rights reserved.
//

import UIKit

extension Feeds {
    // MARK: - Static Methods
    /// Save selected feeds to user defaults
    static func save() {
        // Save feeds IDs for all
        UserDefaults.selectedFeedsIDs = [String](all.selected.feedsIDs)
    }
    
    /// Load selected feeds from user defaults
    static func restore() {
        for feed in Feeds.all {
            guard !UserDefaults.selectedFeedsIDs.isEmpty else { return }
            
            // Check saved id into current FeedsSource
            guard let feedIDs = UserDefaults.selectedFeedsIDs.first(where: { $0 == feed.id }) else {
                feed.shouldUse = false
                continue
            }
            
            guard let feed = Feeds.all.first(where: { $0.id == feedIDs }) else {
                debug("WARNING: Can't find \(feedIDs) into \(Feeds.all)")
                return
            }
            
            feed.shouldUse = true
        }
    }
}
