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
    private(set) static var items = [Wishlist]()
    
    /// List of outfits added by the user to the wishlist
    private(set) static var outfits = [Wishlist]()
    
    // MARK: - Static Methods
    /// Add an item to the items wishlist if it is not present there
    /// - Parameter item: item to add to the wishlist
    static func add(item: Item?) {
        // Make sure we don't have item added already
        guard let item = item, contains(item: item) == false else { return }
        
        // Append the item to the end of the wishlist
        Wishlist.items.append(Wishlist(item))
    }
    
    /// Returns true if item is contained in the items wishlist already, false otherwise
    /// - Parameter item: item to check for inclusion into the collection
    /// - Returns: true if item is contained in the items wishlist, false if not, nil if item's itemIndex is nil
    static func contains(item: Item) -> Bool? {
        guard let itemIndex = item.itemIndex else { return nil }
        return Wishlist.items.contains { $0.item?.itemIndex == itemIndex }
    }
    
    // MARK: - Stored Properties
    /// The list of items or a single item in the wishlist element
    private(set) var items: [Item]
    
    /// Occasion for a single item
    private(set) var occasion: String?
    
    // MARK: - Computed Properties
    /// Single item in the wishlist element
    private(set) var item: Item? {
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
    
    // MARK: - Init
    private init(_ item: Item) {
        items = [item]
    }
    
    private init(_ items: [Item], occasion: String) {
        self.items = items
        self.occasion = occasion
    }
}
