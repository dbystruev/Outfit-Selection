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
    private(set) static var items = [Wishlist]() {
        didSet {
            debug(items.count)
        }
    }
    
    /// List of outfits added by the user to the wishlist
    private(set) static var outfits = [Wishlist]() {
        didSet {
            debug(outfits.count)
        }
    }
    
    // MARK: - Static Methods
    /// Add an item to the items wishlist if it is not present there
    /// - Parameter item: item to add to the item wishlist
    static func add(item: Item?) {
        // Make sure we don't have item added already
        guard let item = item, contains(item) == false else { return }
        
        // Append the item to the end of the items wishlist
        items.append(Wishlist(item))
    }
    
    /// Add items to the outfit wishlist if they are not present there
    /// - Parameters:
    ///   - items: the list of items to add to the outfit wishlist
    ///   - occasion: Occasion for the outfit
    static func add(items: [Item], occasion: String) {
        // Make sure we don't add an empty or existing wishlist
        let outfit = Wishlist(items, occasion: occasion)
        guard contains(outfit) == false else { return }
        
        // Append the new outfit to the end of the outfits wishlist
        outfits.append(outfit)
    }
    
    /// Returns true if item is contained in the items wishlist already, false otherwise
    /// - Parameter item: item to check for inclusion into the collection
    /// - Returns: true if item is contained in the items wishlist, false if not, nil if item's itemIndex is nil
    static func contains(_ item: Item) -> Bool? {
        guard let itemIndex = item.itemIndex else { return nil }
        return items.contains { $0.item?.itemIndex == itemIndex }
    }
    
    /// Returns true if outfit is contained in the outfit wishlist already, false otherwise
    /// - Parameter newOutfit: the collection of items in the outfit
    /// - Returns: true if outfit is container in the outfit wishlist, false if not, nil if outfit is empty
    static func contains(_ newOutfit: Wishlist) -> Bool? {
        let newOutfitCount = newOutfit.items.count
        guard 0 < newOutfitCount else { return nil }
        for outfit in outfits {
            // Skip outfits with different number of items
            guard newOutfitCount == outfit.items.count else { continue }
            
            // Make two sets of outfit item indexes
            let newOutfitSet = Set(newOutfit.items.compactMap { $0.itemIndex })
            let outfitSet = Set(outfit.items.compactMap { $0.itemIndex })
            
            // Compare two sets of outfit item indexes
            if newOutfitCount == newOutfitSet.count && newOutfitSet == outfitSet {
                return true
            }
        }
        return false
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
    
    // MARK: - Init
    private init(_ item: Item) {
        items = [item]
    }
    
    private init(_ items: [Item], occasion: String) {
        self.items = items
        self.occasion = occasion
    }
}
