//
//  Items.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 29.10.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

typealias Items = [Item]

extension Items {
    // MARK: - Static Stored Properties
    /// All items loaded from the server
    private(set) static var byID = [String: Item]()
    
    /// The maximum number of items for one outfit corner
    static let maxCornerCount = 50
    
    // MARK: - Static Computed Properties
    /// The number of items
    static var count: Int { byID.count }
    
    // MARK: - Static Methods
    /// Appends items to Item.all. Mimics generic collection's method append(contentsOf:) while saving current index in itemIndex property of each item
    /// - Parameter newItems: collection of new items to be added to the Item.all
    static func append(contentsOf newItems: Items) {
        newItems.forEach { byID[$0.id] = $0 }
    }
    
    /// Dislikes given item in Item.all
    /// - Parameter item: the item to be disliked
    static func dislike(_ item: Item?) {
        item?.disliked = true
    }
    
    /// Clears all items
    static func removeAll() {
        byID.removeAll()
    }
    
    /// Update all items vendor names to full versions
    /// - Parameter fullVendorNames: the dictionary with short : full vendor names
    static func updateVendorNames(with fullVendorNames: [String: String]) {
        byID.forEach { $0.value.updateVendorName(with: fullVendorNames) }
    }
    
    // MARK: - Computed Properties
    /// IDs of items
    var IDs: [String] { map { $0.id }}
}
