//
//  FeedKind.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 28.09.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

/// There are 3 kinds of feed cell so far
enum FeedKind: String, CaseIterable, CustomStringConvertible {
    case brands
    case newItems
    case occasions
    case sale
    
    // CustomStringConvertible
    var description: String { rawValue }
    
    var title: String {
        switch self {
        case .brands:
            return "Favorite brands"
        case .newItems:
            return "New items for you"
        case .occasions:
            return "Occasions"
        case .sale:
            return "Sales"
        }
    }
}
