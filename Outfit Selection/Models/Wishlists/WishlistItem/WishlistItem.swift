//
//  WishlistItem.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 08.09.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import Foundation

final class WishlistItem: Decodable {
    
    // MARK: - Types
    enum CodingKeys: String, CodingKey {
        case gender
        case itemIDs = "item_ids"
        case kind
        case name
    }
    
    /// Type (kind) of wishlist item
    enum Kind: Int, Codable, CustomStringConvertible {
        case collection
        case item
        case outfit
        
        // MARK: - CustomStringConvertible
        var description: String {
            switch self {
            
            case .collection:
                return ".collection"
                
            case .item:
                return ".item"
                
            case .outfit:
                return ".outfit"
                
            }
        }
    }
    
    // MARK: - Stored Properties
    /// Gender of wishlist item
    var gender: Gender
    
    /// Type (kind) of wishlist item
    var kind: Kind
    
    /// Item IDs which are loaded first and load items by ids
    let itemIDs: [String]

    /// The dictionary of items (or one item in case of .item type)
    var items: [String: Item] = [:]    
    
    /// Name for collection, item, or occasion for outfit
    var name: String?
    
    // MARK: - Computed Properties
    /// The first item of the items array
    var item: Item? { items.values.first }
    
    /// The set of items ids
    var itemsIdSet: Set<String> { Set(itemIDs)}
    
    /// Calculate wishlist items price
    var price: Double {
        items.values.reduce(0) { $0 + $1.price }
    }
    
    // MARK: - Init
    init(gender: Gender, kind: Kind, items: [Item], name: String) {
        self.gender = gender
        self.kind = kind
        var newItems: [String: Item] = [:]
        items.forEach { newItems[$0.id] = $0 }
        self.items = newItems
        itemIDs = items.map { $0.id }
        self.name = name
    }
    
    // MARK: - Decodable
    required init(from decoder: Decoder) throws {
        // Get values from the container
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        // Decode all properties
        gender = try values.decode(Gender.self, forKey: .gender)
        kind = try values.decode(Kind.self, forKey: .kind)
        name = try? values.decode(String.self, forKey: .name)
        itemIDs = try values.decode([String].self, forKey: .itemIDs)
        
        // Set already loaded items
        itemIDs.forEach {
            guard let item = Item.all[$0] else { return }
            items[$0] = item
        }
        
        // Load new wishlist items not present in the items
        let newItemIDs = itemIDs.filter { items[$0] == nil }
        NetworkManager.shared.getItems(newItemIDs) { newItems in
            newItems?.forEach { self.items[$0.id] = $0 }
        }

    }
}
