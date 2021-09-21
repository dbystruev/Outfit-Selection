//
//  CollectionItem.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 06.09.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

struct CollectionItem: Codable {
    
    // MARK: - Types
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
    
    /// Single item or a few items depending on collection item type
    let items: [Item]
    
    // MARK: - Computed Properties
    /// The list of item ids
    var itemIds: [String] {
        items.map { $0.id }
    }
    
    // MARK: - Init
    init?(_ item: Item?) {
        guard let item = item else { return nil }
        kind = .item
        items = [item]
    }
    
    init?(_ outfit: [Item]?) {
        guard let outfit = outfit, !outfit.isEmpty else { return nil }
        kind = .outfit
        items = outfit
    }
}
