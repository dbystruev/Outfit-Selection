//
//  WishlistItem+Decodable.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 22.09.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

extension WishlistItem: Decodable {
    enum CodingKeys: String, CodingKey {
        case gender
        case itemIDs = "item_ids"
        case kind
        case name
    }
    
    init(from decoder: Decoder) throws {
        // Get values from the container
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        // Decode all properties
        gender = try values.decode(Gender.self, forKey: .gender)
        let itemIDs = try values.decode([String].self, forKey: .itemIDs)
        items = itemIDs.compactMap { Item.all[$0] }
        kind = try values.decode(Kind.self, forKey: .kind)
        name = try? values.decode(String.self, forKey: .name)
    }
}
