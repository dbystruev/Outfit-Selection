//
//  Feed.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 03.05.2022.
//  Copyright © 2022 Denis Bystruev. All rights reserved.
//

import Foundation

// Matches http://oracle.getoutfit.net:3000/feeds
public class Feed: Codable {
    /// Unique feed ID, e.g. "ounass.ae.en.aed"", matches feed in Item
    let id: String
    
    /// Currncy symbol, e.g. "DH" or "₽"
    let currency: String
    
    /// True if the feed should be used, false otherwise
    var shouldUse: Bool
    
    /// Date when the feed was created
    let createdAt: Date
    
    /// Public name of the feed, e.g. "Ounass"
    let name: String
    
    /// Public feed picture URL or data, e.g. "https://www.farfetch.com/static/images/logo.png" or "data:image/png;base64,iVBO..."
    let picture: URL?
    
    enum CodingKeys: String, CodingKey {
        case currency
        case id
        case shouldUse = "in_use"
        case createdAt = "created_at"
        case name
        case picture
    }
    
    // MARK: - Decodable
    required public init(from decoder: Decoder) throws {
        // Get values from the container
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        // Decode each of the properties
        currency = try values.decode(String.self, forKey: .currency)
        id = try values.decode(String.self, forKey: .id)
        shouldUse = try values.decode(Bool.self, forKey: .shouldUse)
        let createdAtTimestamp = try values.decode(String.self, forKey: .createdAt)
        createdAt = Timestamp.formatter.date(from: createdAtTimestamp) ?? Date()
        name = try values.decode(String.self, forKey: .name)
        picture = try? values.decode(URL.self, forKey: .picture)
    }
    
    // MARK: - Methods
    /// Select / deselect this occasion without updating user defaults
    /// - Parameter shouldUse: true if should select, false if should unselect
    func selectWithoutSaving(_ shouldUse: Bool) {
        self.shouldUse = shouldUse
    }
}
