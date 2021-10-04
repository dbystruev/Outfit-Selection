//
//  CollectionItem.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 06.09.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

final class CollectionItem: Codable {
    
    // MARK: - Types
    enum CodingKeys: String, CodingKey {
        case itemIDs = "item_ids"
        case kind
    }
    
    /// There are 2 types of collections: with items or with looks of items
    enum Kind: Int, Codable, CustomStringConvertible {
        case item
        case outfit
        
        // CustomStringConvertible
        var description: String {
            switch self {
            
            case .item:
                return ".item"
                
            case .outfit:
                return ".outfit"
                
            }
        }
    }
    
    // MARK: - Stored Properties
    /// Kind (type) of the collection item
    let kind: Kind
    
    /// The list of item ids
    let itemIDs: [String]
    
    /// The dictionary of items (or single item in case of .item type)
    var items: [String: Item] = [:]
    
    // MARK: - Init
    init?(_ item: Item?) {
        guard let item = item else { return nil }
        kind = .item
        itemIDs = [item.id]
        items = [item.id: item]
    }

    init?(_ outfit: [Item]?) {
        guard let outfit = outfit, !outfit.isEmpty else { return nil }
        kind = .outfit
        itemIDs = outfit.map { $0.id }
        outfit.forEach { items[$0.id] = $0 }
    }
    
    // MARK: - Decodable
    required init(from decoder: Decoder) throws {
        // Get values from the container
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        // Decode all properties
        kind = try values.decode(Kind.self, forKey: .kind)
        itemIDs = try values.decode([String].self, forKey: .itemIDs)
        
        // Set already loaded items
        itemIDs.forEach {
            guard let item = Item.all[$0] else { return }
            items[$0] = item
        }
        
        // Load new collection items not present in the global items
        let newItemIDs = itemIDs.filter { items[$0] == nil }
        NetworkManager.shared.getItems(newItemIDs) { newItems in
            newItems?.forEach { self.items[$0.id] = $0 }
        }
    }
}
