//
//  Feeds.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 03.05.2022.
//  Copyright © 2022 Denis Bystruev. All rights reserved.
//

public typealias Feeds = [Feed]

extension Feeds {
    // MARK: - Stored Properties
    /// All shouldUse feeds
    var shouldUse: Feeds { filter { $0.shouldUse } }
    
    // MARK: - Stored Static Properties
    /// The full  list of feeds
    public static var all: Feeds = []
    
    /// All shouldUse feeds
    static var shouldUse: Feeds { all.shouldUse }
}
