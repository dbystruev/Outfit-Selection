//
//  WishlistItem.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 08.09.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import Foundation

struct WishlistItem: Codable {
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
    /// Type (kind) of wishlist item
    var kind: Kind
}
