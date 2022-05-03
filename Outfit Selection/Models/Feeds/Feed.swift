//
//  Feed.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 03.05.2022.
//  Copyright © 2022 Denis Bystruev. All rights reserved.
//

import Foundation

// Matches http://oracle.getoutfit.net:3000/feeds
public struct Feed: Codable {
    /// Unique feed ID, e.g. "tsum.2022-05-02", matches feed in Item
    let id: String
    
    /// True if the feed should be used, false otherwise
    let shouldUse: Bool
    
    /// Date when the feed was created
    let createdAt: Date
    
    /// Public name of the feed, e.g. "TSUM"
    let name: String
    
    /// Public feed picture URL, e.g. "https://www.farfetch.com/static/images/logo.png"
    let picture: URL?
    
    enum CodingKeys: String, CodingKey {
        case id
        case shouldUse = "in_use"
        case createdAt = "created_at"
        case name
        case picture
    }
}
