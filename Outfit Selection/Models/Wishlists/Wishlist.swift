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
    /// Suggests what to select next time when opening wishlist
    static var tabSuggested: WishlistItemCatalog.Kind?
    
    // MARK: - Computed Static Properties
    /// All items in collections, item wishlist, and outfit wishlist
    static var allItems: Items {
        let items = all.flatMap { $0.items.values }
        return items
    }
    
    /// Set of item indexes in both item wishlist and outfit wishlist
    static var allItemsIdSet: Set<String> {
        collectionsItemsIdSet.union(itemsIdSet.union(outfitsItemsIdSet))
    }
    
    /// Wishlist items with type .collection
    static var collections: [WishlistItemCatalog] {
        all.filter { $0.kind == .collection }
    }
    
    /// The items inside all collections
    static var collectionsItems: Items {
        collections.flatMap { $0.items.values }
    }
    
    /// Set of item indexes found in collections
    static var collectionsItemsIdSet: Set<String> {
        Set(collectionsItems.IDs)
    }
    
    /// Wishlist items with type .item
    static var items: [WishlistItemCatalog] {
        all.filter { $0.kind == .item }
    }
    
    /// Set of item indexes found in items
    static var itemsIdSet: Set<String> {
        Set(items.compactMap { $0.item?.id })
    }
    
    /// Returns the type (kind) of the largerst wishlist
    static var largestKind: WishlistItemCatalog.Kind? {
        let sortedWishlists = [collections, items, outfits].sorted { $1.count < $0.count }
        let largestWishlist = sortedWishlists[0]
        return largestWishlist.first?.kind
    }
    
    /// Wishlist items with type .outfit
    static var outfits: [WishlistItemCatalog] {
        all.filter { $0.kind == .outfit }
    }
    
    /// The items inside all outfits
    static var outfitsItems: Items {
        outfits.flatMap { $0.items.values }
    }
    
    /// Set of item indexes found in outfits
    static var outfitsItemsIdSet: Set<String> {
        Set(outfitsItems.IDs)
    }
    
    // MARK: - Static Methods
    /// Add an item to the items wishlist if it is not present there
    /// - Parameter item: the item to add to the item wishlist
    static func add(_ item: Item?) {
        // Make sure we don't have item added already
        guard let item = item, contains(item) == false else { return }
        
        // Append the item to the end of the wishlist items
        guard let gender = Gender.current else {
            debug("WARNING: Gender.current is empty")
            return
        }
        Wishlist.append(WishlistItemCatalog(gender: gender, kind: .item, items: [item], name: item.name))
        
        // Remember that item is in the wishlist
        item.setWishlisted()
    }
    
    /// Add items to the outfit wishlist if they are not present there
    /// - Parameters:
    ///   - items: the list of items to add to the outfit wishlist
    ///   - occasion: Occasion for the outfit
    static func add(_ items: Items, occasion: String) {
        // Make sure we don't add an empty wishlist with no occasion
        guard 0 < items.count && !occasion.isEmpty else { return }
        
        // Check if similar items exist in any occasion, clear it if found
        remove(items)
        
        // Append the new outfit to the end of the outfits wishlist
        guard let gender = Gender.current else {
            debug("WARNING: Gender.current is empty")
            return
        }
        
        Wishlist.append(WishlistItemCatalog(gender: gender, kind: .outfit, items: items, name: occasion))
        
        // Set each item's wishlisted property
        items.forEach { $0.setWishlisted() }
    }
    
    /// Returns true if items count equals and items IDs equals too
    /// - Parameters:
    ///   - items: the items in the outfit
    ///   - outfit: the wishlist items catalog
    /// - Returns: true if item count and outfit items cout equal
    static func checkCount(items: Items, outfit: WishlistItemCatalog) -> Bool {
        
        // Return false if the number of items in the outfits differ
        guard items.count == outfit.items.count else { return false }
        
        // Make two sets of outfit item indexes
        let newOutfitSet = Set(items.IDs)
        
        // Compare two sets of outfit item indexes
        return newOutfitSet == outfit.itemsIdSet
    }
    
    /// Clear wishlisted status
    /// - Parameters
    /// - items: the items in outfit to remove
    /// - outfit where find items
    private static func clearWishlisted(items: Items, outfit: WishlistItemCatalog ) {
        Wishlist.removeAll { $0 == outfit }
        items.forEach {
            // Check that the item is not in the item wishlist
            guard contains($0) != true else { return }
            
            // Confirm that the item is not in the outfit wishlist
            guard contains(itemInOutfits: $0) != true else { return }
            
            // Clear wishlisted status
            $0.setWishlisted(to: false)
        }
    }
    
    /// Returns true if item is contained in the items wishlist already, false otherwise
    /// - Parameters:
    ///   - item: item to check for inclusion into the collection
    /// - Returns: true if item is contained in the items wishlist, false if not
    static func contains(_ item: Item) -> Bool {
        itemsIdSet.contains(item.id)
    }
    
    /// Returns true if outfit is contained in the outfit wishlist already, false otherwise
    /// - Parameters:
    ///   - items: the items in the new outfit
    ///   - occasion: the occasion for the outfit, if nil search all occasions
    /// - Returns: true if outfit is contained in the outfit wishlist, false if not, nil if items or occasion are empty
    static func contains(_ items: Items, occasion: String? = nil) -> Bool? {
        // Return nil if new items or occasion is empty
        let itemsCount = items.count
        guard 0 < itemsCount && occasion?.isEmpty != true else { return nil }
        
        // If occasion is nil search for all occasions
        guard let occasion = occasion else {
            for outfit in outfits {
                if contains(items, occasion: outfit) == true { return true }
            }
            return false
        }
        
        // Return false if there is no outfit for the occasion present
        guard let outfit = outfits.first(where: { $0.name == occasion }) else { return false }
        return checkCount(items: items, outfit: outfit)
    }
    
    /// Returns true if outfit is contained in the outfit wishlist already, false otherwise
    /// - Parameters:
    ///   - items: the items in the outfit
    ///   - occasion: the wishlist items catalog
    /// - Returns: true if outfit is contained in the outfit wishlist, false if not
    static func contains(_ items: Items, occasion: WishlistItemCatalog) -> Bool? {
        
        // Return false if there is no outfit for the occasion present
        guard let outfit = outfits.first(where: { $0 == occasion }) else { return false }
        return checkCount(items: items, outfit: outfit)
    }
    
    /// Returns true if occasion exists in outfits dictionary, false otherwise
    /// - Parameter occasion: the occasion to search for
    static func contains(_ occasion: String) -> Bool {
        outfits.first { $0.name == occasion } != nil
    }
    
    /// Returns true if item is found in outfit wishlist, false otherwise
    /// - Parameter item: item to check for inclusion into the outfit wishlist
    /// - Returns: true if item is found in outfit wishlist, false otherwise
    static func contains(itemInOutfits item: Item) -> Bool {
        outfitsItemsIdSet.contains(item.id)
    }
    
    /// Finds given items in the wishlist and returns occasion name for them, or nil if there are no such items in the wishlist
    /// - Parameter items: the collection of items to search for in the wishlist
    /// - Returns: occasion name for the given items, or nil if there are no occasion with such items
    static func occasion(_ items: Items) -> String? {
        for outfit in outfits {
            if contains(items, occasion: outfit.name) == true { return outfit.name }
        }
        return nil
    }
    
    /// Remove an item from the items wishlist if it is present there
    /// - Parameter item: the item to remove from the item wishlist
    static func remove(_ item: Item) {
        // Remove items with given item id
        Wishlist.removeAll { $0.kind == .item && $0.items.values.first?.id == item.id }
        
        // Clear wishlisted status if not found in outfit wishlist
        guard !contains(itemInOutfits: item) else { return }
        item.setWishlisted(to: false)
    }
    
    /// Remove items from the outfit wishlist if they are present there
    /// - Parameters
    /// - items: the items in outfit to remove
    /// - name: find items use name
    static func remove(_ items: Items, with name: Bool = true) {
        if name {
            // Check all occasions and remove similar items from them
            for outfit in outfits {
                if contains(items, occasion: outfit.name) == true {
                    clearWishlisted(items: items, outfit: outfit)
                }
            }
        } else {
            // Check all occasions and remove similar items from them
            for outfit in outfits {
                if contains(items, occasion: outfit) == true {
                    clearWishlisted(items: items, outfit: outfit)
                }
            }
        }
    }
    
}
