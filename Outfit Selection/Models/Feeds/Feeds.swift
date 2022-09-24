//
//  Feeds.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 03.05.2022.
//  Copyright © 2022 Denis Bystruev. All rights reserved.
//

import Algorithms

// Matches http://oracle.getoutfit.net:3000/feeds
public typealias Feeds = [Feed]

extension Feeds {
    // MARK: - Stored Static Properties
    /// The full  list of feeds
    public static var all: Feeds = [] {
        didSet {
            zip(all.feedsIDs, all).forEach { ((byID[$0]) = $1) }
        }
    }
        
    /// FeedProfile by ID
    private(set) static var byID: [String: Feed] = [:]
    
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
    var selected: Feeds { filter { $0.shouldUse } }
    
    /// All selected feeds
    var unselected: Feeds { filter { !$0.shouldUse } }
    
    // MARK: - Static Methods
    /// Select/deselect all feeds with given
    /// - Parameters:
    ///   - feed: the FeedsProfile to search for
    ///   - shouldSelect: true to select, false to unselect
    static func select(feed: Feed, shouldUse: Bool) {
        let feed = Feeds.all.first(where: { $0.id == feed.id })
        feed?.shouldUse = shouldUse
    }
    
    /// Select/deselect all occasions with given title without saving to user defaults
    /// - Parameters:
    ///   - feed: the FeedsProfile to search for
    ///   - shouldUse: true to select, false to unselect
    static func selectWithoutSaving(feed: Feed, shouldUse: Bool) {
        Feeds.all.forEach { $0.selectWithoutSaving(shouldUse) }
    }
}
