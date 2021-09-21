//
//  WishlistItem.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 08.09.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import Foundation

struct WishlistItem {
    // MARK: - Types
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
    
    /// The list of items (or one item in case of .item type)
    var items: [Item]
    
    /// Name for collection, item, or occasion for outfit
    var name: String?
    
    // MARK: - Computed Properties
    /// The first item of the items array
    var item: Item? { items.first }
    
    /// The set of items ids
    var itemsIdSet: Set<String> { Set(items.map { $0.id })}
    
    /// Calculate wishlist items price
    var price: Double {
        items.reduce(0) { $0 + $1.price }
    }
}

extension WishlistItem: Equatable {}
