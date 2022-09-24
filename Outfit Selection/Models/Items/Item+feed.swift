//
//  Item+feed.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 04.09.2022.
//  Copyright © 2022 Denis Bystruev. All rights reserved.
//

extension Item {
    /// Return feed matching the item
    var feed: Feed? {
        guard let feedID = feedID else { return nil }
        return Feeds.byID[feedID]
    }
}
