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
    enum Kind {
        case collection
        case item
        case outfit
    }
}
