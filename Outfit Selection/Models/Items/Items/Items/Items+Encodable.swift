//
//  Items+Encodable.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 04.10.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

// MARK: - Encodable
extension Items: Encodable {
    func encode(to encoder: Encoder) throws {
        // Create encode container
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        // Encode properties
        try container.encode(itemIDs, forKey: .itemIDs)
        try container.encode(kind, forKey: .kind)
    }
}
