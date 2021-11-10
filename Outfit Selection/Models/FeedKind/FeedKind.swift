//
//  FeedKind.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 28.09.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

/// There are 3 kinds of feed cell so far
enum FeedKind {
    // MARK: - Computed Static Properties
    static var primary: [FeedKind] {
        [.brands, .newItems, .sale]
    }
    
    // MARK: - Enum
    case brands
    case collections(String)
    case newItems
    case occasions(Int)
    case sale
    
    // MARK: - Computed Properties
    /// Title in feed collection section
    var title: String? {
        switch self {
        case .brands:
            return "Favorite brands"~
        case .collections(let name):
            return name
        case .newItems:
            return "New items for you"~
        case .occasions(let id):
            guard let occasion = Occasions.byID[id] else { return nil }
            return occasion.title
        case .sale:
            return "Sales"~
        }
    }
}

extension FeedKind: Equatable {}
extension FeedKind: Hashable {}
