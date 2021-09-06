//
//  CollectionItem.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 06.09.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

struct CollectionItem {
    
    /// Kind (type) of the collection item
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
}
