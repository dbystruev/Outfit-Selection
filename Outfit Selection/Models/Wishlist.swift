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
    // MARK: - Stored Static Properties
    /// List of items added by the user to the wishlist
    private(set) static var items = [Wishlist]()
    
    /// Dictinary (map) of outfits added by the user to the wishlist
    private static var outfitsDictionary = [String: [Item]]()
    
    // MARK: - Computed Static Properties
    /// List of outfits added by the user to the wishlist
    static var outfits: [Wishlist] {
        outfitsDictionary.map { Wishlist($0.value, occasion: $0.key) }
    }
    
    // MARK: - Static Methods
    /// Add an item to the items wishlist if it is not present there
    /// - Parameter item: the item to add to the item wishlist
    static func add(_ item: Item?) {
        // Make sure we don't have item added already
        guard let item = item, contains(item) == false else { return }
        
        // Append the item to the end of the items wishlist
        items.append(Wishlist(item))
    }
    
    /// Add items to the outfit wishlist if they are not present there
    /// - Parameters:
    ///   - items: the list of items to add to the outfit wishlist
    ///   - occasion: Occasion for the outfit
    static func add(_ items: [Item], occasion: String) {
        // Make sure we don't add an empty wishlist with no occasion
        guard 0 < items.count && !occasion.isEmpty else { return }
        
        // Check if similar items exist in any occasion, clear it if found
        remove(items)
        
        // Append the new outfit to the end of the outfits wishlist
        outfitsDictionary[occasion] = items
    }
    
    /// Returns true if item is contained in the items wishlist already, false otherwise
    /// - Parameter item: item to check for inclusion into the collection
    /// - Returns: true if item is contained in the items wishlist, false if not, nil if item or its itemIndex is nil
    static func contains(_ item: Item?) -> Bool? {
        guard let itemIndex = item?.itemIndex else { return nil }
        return items.contains { $0.item?.itemIndex == itemIndex }
    }
    
    /// Returns true if outfit is contained in the outfit wishlist already, false otherwise
    /// - Parameters:
    ///   - newOutfit: the collection of items in the new outfit
    ///   - occasion: the occasion for the outfit, if nil search all occasions
    /// - Returns: true if outfit is contained in the outfit wishlist, false if not, nil if items or occasion are empty
    static func contains(_ newOutfit: [Item], occasion: String? = nil) -> Bool? {
        // Return nil if new items or occasion is empty
        let newOutfitCount = newOutfit.count
        guard 0 < newOutfitCount && occasion?.isEmpty != true else { return nil }
        
        // If occasion is nil search for all occasions
        guard let occasion = occasion else {
            for occasion in outfitsDictionary.keys {
                if contains(newOutfit, occasion: occasion) == true { return true }
            }
            return false
        }
        
        // Return false if there is no outfit for the occasion present
        guard let outfit = outfitsDictionary[occasion] else { return false }
        
        // Return false if the number of items in the outfits differ
        guard newOutfitCount == outfit.count else { return false }
        
        // Make two sets of outfit item indexes
        let newOutfitSet = Set(newOutfit.compactMap { $0.itemIndex })
        let outfitSet = Set(outfit.compactMap { $0.itemIndex })
        
        // Compare two sets of outfit item indexes
        return newOutfitCount == newOutfitSet.count && newOutfitSet == outfitSet
    }
    
    /// Returns true if occasion exists in outfits dictionary, false otherwise
    /// - Parameter occasion: the occasion to search for
    static func contains(_ occasion: String) -> Bool {
        outfitsDictionary[occasion] != nil
    }
    
    /// Remove an item from the items wishlist if it is present there
    /// - Parameter item: the item to remove from the item wishlist
    static func remove(_ item: Item?) {
        // Make sure the item amd its index are not nil
        guard let itemIndex = item?.itemIndex else { return }
        
        // Remove all items with given itemIndex
        items.removeAll { $0.item?.itemIndex == itemIndex }
    }
    
    /// Remove items from the outfit wishlist if they are present there
    /// - Parameter items: the items in outfit to remove
    static func remove(_ items: [Item]) {
        // Check all occasions and remove similar items from them
        for occasion in outfitsDictionary.keys {
            if contains(items, occasion: occasion) == true {
                outfitsDictionary[occasion] = nil
            }
        }
    }
    
    // MARK: - Stored Properties
    /// The list of items or a single item in the wishlist element
    private(set) var items: [Item]
    
    /// Occasion for the list of items
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
    
    /// Calculate wishlist items price
    var price: Double {
        items.reduce(0) { $0 + ($1.price ?? 0) }
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
