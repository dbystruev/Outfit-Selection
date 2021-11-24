//
//  Wishlist+all.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 08.09.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import Foundation

extension Wishlist {
    // MARK: - Stored Static Properties
    /// Wishlist items added by the user to the wishlist
    private static var _all: [Gender: [WishlistItemCatalog]] = [:]
    
    /// Wishlist items saved to user default every time they are updated
    private(set) static var all: [WishlistItemCatalog] {
        get {
            guard let gender = Gender.current else { return [] }
            return _all[gender] ?? []
        }
        set {
            guard let gender = Gender.current else { return }
            guard newValue != _all[gender] else { return }
            _all[gender] = newValue
            save()
        }
    }
    
    static func append(_ wishlistItem: WishlistItemCatalog) {
        all.append(wishlistItem)
    }
    
    /// Clear both items and outfit wishlists
    static func removeAll(where shouldBeRemoved: (WishlistItemCatalog) -> Bool) {
        all.removeAll(where: shouldBeRemoved)
    }
    
    /// Update all items vendor names to full versions
    /// - Parameter fullVendorNames: the dictionary with short : full vendor names
    static func updateVendorNames(with fullVendorNames: [String: String]) {
        _all.forEach { wishlistItems in
            wishlistItems.value.forEach {
                $0.updateVendorNames(with: fullVendorNames)
            }
        }
    }
}


// MARK: - User Defaults
extension Wishlist {
    // MARK: - Methods
    /// Load wishlist from user defaults
    static func restore() {
        guard let data = UserDefaults.wishlists else {
            debug("WARNING: Can't find wishlists data in user defaults")
            return
        }
        
        guard let wishlistItems = try? PList.decoder.decode([WishlistItemCatalog].self, from: data) else {
            debug("WARNING: Can't decode wishlists \(data) from user defaults to \([WishlistItemCatalog].self)")
            return
            
        }
        
        var messages: [String] = []
        for gender in Gender.allCases {
            _all[gender] = wishlistItems.filter { $0.gender == gender }
            guard let items = _all[gender] else { continue }
            let count = items.reduce(0) { $0 + $1.itemIDs.count }
            messages.append("\(count) \(gender)")
        }
        debug("Wishlists:", messages.joined(separator: ", "), "item IDs loaded")
    }
    
    /// Save wishlist to user defaults
    static func save() {
        let wishlistItems = _all.values.flatMap { $0 }
        guard let data = try? PList.encoder.encode(wishlistItems) else {
            debug("WARNING: Can't encode \(all.count) wishlist items for user defaults")
            return
        }
        
        debug("DEBUG: Saving \(data) to user defaults wishlists")
        UserDefaults.wishlists = data
    }
}
