//
//  CollectionItem.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 06.09.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

struct CollectionItem {
    
    // MARK: - Types
    /// There are 2 types of collections: with items or with looks of items
    enum Kind: CustomStringConvertible {
        case item
        case look
        
        // CustomStringConvertible
        var description: String {
            switch self {
            
            case .item:
                return ".item"
                
            case .look:
                return ".look"
            }
        }
    }
    
    // MARK: - Stored Properties
    /// Kind (type) of the collection item
    let kind: Kind
    
    /// Single item or a few items depending on collection item type
    let items: [Item]
    
    // MARK: - Init
    init(item: Item) {
        kind = .item
        items = [item]
    }
    
    init(look: [Item]) {
        kind = .look
        items = look
    }
}
