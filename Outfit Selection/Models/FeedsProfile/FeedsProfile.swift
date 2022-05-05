//
//  FeedsProfile.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 03.05.2022.
//  Copyright © 2022 Denis Bystruev. All rights reserved.
//

import Algorithms

public typealias FeedsProfile = [FeedProfile]

extension FeedsProfile {
    // MARK: - Stored Static Properties
    /// The full  list of feeds
    public static var all: FeedsProfile = []
    
    // MARK: - Stored Properties
    /// All uniqued IDs
    var feedsIDs: UniquedSequence<[String], String> {
        map { $0.id }.uniqued()
    }
    /// FeedsSourc names
    var names: UniquedSequence<[String], String> {
        map { $0.name }.uniqued()
    }
    /// All selected feeds
    var selected: FeedsProfile { filter { $0.shouldUse } }
    
    /// All selected feeds
    var unselected: FeedsProfile { filter { !$0.shouldUse } }
    
    // MARK: - Static Methods
    /// Select/deselect all feeds with given
    /// - Parameters:
    ///   - feed: the FeedsProfile to search for
    ///   - shouldSelect: true to select, false to unselect
    static func select(feed: FeedProfile, shouldUse: Bool) {
        let feed = FeedsProfile.all.first(where: { $0.id == feed.id })
        feed?.shouldUse = shouldUse
    }
    
    /// Select/deselect all occasions with given title without saving to user defaults
    /// - Parameters:
    ///   - feed: the FeedsProfile to search for
    ///   - shouldUse: true to select, false to unselect
    static func selectWithoutSaving(feed: FeedProfile, shouldUse: Bool) {
        FeedsProfile.all.forEach { $0.selectWithoutSaving(shouldUse) }
    }
}
