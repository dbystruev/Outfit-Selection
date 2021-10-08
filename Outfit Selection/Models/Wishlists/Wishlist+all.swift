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
    private static var _all: [Gender: [WishlistItems]] = [:]
    
    /// Wishlist items saved to user default every time they are updated
    private(set) static var all: [WishlistItems] {
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
    
    static func append(_ wishlistItem: WishlistItems) {
        all.append(wishlistItem)
    }
    
    /// Clear both items and outfit wishlists
    static func removeAll(where shouldBeRemoved: (WishlistItems) -> Bool) {
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
    // MARK: - Static Constants
    /// User defaults key
    static let userDefaultsKey = "GetOutfitWishlistKey"
    
    // MARK: - Methods
    /// Load wishlist from user defaults
    static func restore() {
        guard let data = UserDefaults.standard.object(forKey: userDefaultsKey) as? Data else {
            debug("WARNING: Can't find data from user defaults for key \(userDefaultsKey)")
            return
        }
        
        guard let wishlistItems = try? PList.decoder.decode([WishlistItems].self, from: data) else {
            debug("WARNING: Can't decode \(data) from user defaults to [WishlistItem] for key \(userDefaultsKey)")
            return
            
        }
        
        var messages: [String] = []
        for gender in Gender.allCases {
            _all[gender] = wishlistItems.filter { $0.gender == gender }
            guard let items = _all[gender] else { continue }
            let count = items.reduce(0) { $0 + $1.itemIDs.count }
            messages.append("\(count) \(gender)")
        }
        debug("\(userDefaultsKey):", messages.joined(separator: ", "), "item ids loaded")
    }
    
    /// Save wishlist to user defaults
    static func save() {
        let wishlistItems = _all.values.flatMap { $0 }
        guard let data = try? PList.encoder.encode(wishlistItems) else {
            debug("WARNING: Can't encode \(all.count) wishlist items for key \(userDefaultsKey)")
            return
        }
        
        debug("DEBUG: Saving \(data) for \(userDefaultsKey)")
        UserDefaults.standard.set(data, forKey: userDefaultsKey)
    }
}
