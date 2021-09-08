//
//  Wishlist+UserDefaults.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 08.09.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import Foundation

extension Wishlist {
    // MARK: - Static Constants
    /// User defaults key
    static let userDefaultsKey = "GetOutfitWishlistKey"
    
    // MARK: - Methods
    /// Load wishlist from user defaults
    func load() {
        
    }
    
    /// Save wishlist to user defaults
    static func save() {
        UserDefaults.standard.set(Wishlist.items, forKey: userDefaultsKey)
    }
}
