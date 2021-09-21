//
//  WishlistItem+Encodable.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 22.09.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

extension WishlistItem: Encodable {
    func encode(to encoder: Encoder) throws {
        // Create encode container
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        // Encode properties
        try container.encode(gender, forKey: .gender)
        try container.encode(items.map { $0.id }, forKey: .itemIDs)
        try container.encode(kind, forKey: .kind)
        if let name = name {
            try container.encode(name, forKey: .name)
        }
    }
}
