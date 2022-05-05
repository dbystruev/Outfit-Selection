//
//  FeedsSource.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 03.05.2022.
//  Copyright © 2022 Denis Bystruev. All rights reserved.
//

import Algorithms

public typealias FeedsSource = [FeedSource]

extension FeedsSource {
    // MARK: - Stored Properties
    /// FeedsSourc names
    var names: UniquedSequence<[String], String> {
        map { $0.name }.uniqued()
    }
    /// All selected feeds
    var selected: FeedsSource { filter { $0.shouldUse } }
    
    // MARK: - Stored Static Properties
    /// The full  list of feeds
    public static var all: FeedsSource = []
    
    // MARK: - Static Methods
    /// Select/deselect all feeds with given
    /// - Parameters:
    ///   - feed: the feedSource to search for
    ///   - shouldSelect: true to select, false to unselect
    static func select(feed: FeedSource, shouldUse: Bool) {
        let feed = FeedsSource.all.first(where: { $0.id == feed.id })
        feed?.shouldUse = shouldUse
    }
    
    /// Select/deselect all occasions with given title without saving to user defaults
    /// - Parameters:
    ///   - feed: the feedSource to search for
    ///   - shouldUse: true to select, false to unselect
    static func selectWithoutSaving(feed: FeedSource, shouldUse: Bool) {
        FeedsSource.all.forEach { $0.selectWithoutSaving(shouldUse) }
    }
}
