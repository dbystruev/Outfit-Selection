//
//  Wishlist.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 25.02.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import Foundation

/// Element of a wishlist
struct Wishlist: Codable {
    // MARK: - Static Properties
    /// List of items added by the user to the wishlist
    static var items = [Wishlist]()
    
    /// List of outfits added by the user to the wishlist
    static var outfits = [Wishlist]()
    
    // MARK: - Stored Properties
    /// The list of items or a single item in the wishlist element
    var items: [Item]
    
    /// Occasion for a single item
    var occasion: String?
    
    // MARK: - Computed Properties
    /// Single item in the wishlist element
    var item: Item? {
        get { items.first }
        set {
            // If new value is nil, clear the array of items
            guard let newValue = newValue else {
                items.removeAll()
                return
            }
            if 0 < items.count {
                items[0] = newValue
            } else {
                items.append(newValue)
            }
        }
    }
}
