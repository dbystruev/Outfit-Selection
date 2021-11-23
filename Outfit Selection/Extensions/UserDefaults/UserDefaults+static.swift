//
//  UserDefaults+static.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 19.10.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//
//  https://www.avanderlee.com/swift/property-wrappers/

import Foundation

extension UserDefaults {
    
    /// Collections data saved by the user
    @UserDefault(key: "GetOutfitCollectionKey", defaultValue: nil)
    static var collections: Data?
    
    /// True if user has seen onboarding
    @UserDefault(key: "GetOutfitHasSeenAppIntroduction", defaultValue: false)
    static var hasSeenAppIntroduction: Bool
    
    /// The list of brands selected by the user
    @UserDefault(key: "GetOutfitSelectedBrandsKey", defaultValue: [])
    static var selectedBrands: [String]
    
    /// The list of occasions selected by the user
    @UserDefault(key: "GetOutfitSelectedOccasionsKey", defaultValue: [])
    static var selectedOccasionTitles: [String]
    
    /// Wishlist items data saved by the user
    @UserDefault(key: "GetOutfitWishlistKey", defaultValue: nil)
    static var wishlists: Data?
}
