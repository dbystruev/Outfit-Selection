//
//  WishlistItemCatalog.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 08.09.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import Foundation

final class WishlistItemCatalog: ItemCatalog {
    
    // MARK: - Types
    enum CodingKeys: String, CodingKey {
        case gender
        case itemIDs = "item_ids"
        case kind
        case name
    }

    // MARK: - Stored Properties
    /// Gender of wishlist item
    var gender: Gender
    
    /// Name for collection, item, or occasion for outfit
    var name: String?
    
    // MARK: - Init
    init(gender: Gender, kind: Kind, items: [Item], name: String) {
        self.gender = gender
        self.name = name
        super.init(kind: kind, itemIDs: items.map { $0.id })
    }
    
    // MARK: - Decodable
    required init(from decoder: Decoder) throws {
        // Get values from the container
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        // Decode own properties
        gender = try values.decode(Gender.self, forKey: .gender)
        name = try? values.decode(String.self, forKey: .name)
        
        // Decode parent properties
        let superDecoder = try values.superDecoder()
        try super.init(from: superDecoder)
    }
    
    // MARK: - Encodable
    override func encode(to encoder: Encoder) throws {
        // Create encode container
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        // Encode own properties
        try container.encode(gender, forKey: .gender)
        if let name = name {
            try container.encode(name, forKey: .name)
        }
        
        // Encode parent properties
        let superEncoder = container.superEncoder()
        try super.encode(to: superEncoder)
    }
}
