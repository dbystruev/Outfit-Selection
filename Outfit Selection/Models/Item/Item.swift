//
//  Item.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 26.10.2020.
//  Copyright © 2020 Denis Bystruev. All rights reserved.
//

import Foundation

struct Item: Codable {
    // MARK: - Static Properties
    /// All items loaded from the server
    private(set) static var all = [Item]()
    
    /// The maximum number of items for all categories together, not all of them displayed
    static let maxCount = 10000
    
    // MARK: - Static Methods
    /// Appends items to Item.all. Mimics generic collection's method append(contentsOf:) while saving current index in itemIndex property of each item
    /// - Parameter newItems: collection of new items to be added to the Item.all
    static func append(contentsOf newItems: [Item]) {
        for var newItem in newItems {
            newItem.itemIndex = all.count
            all.append(newItem)
        }
    }
    
    // MARK: - Stored Properties
    /// Item's category id
    let categoryId: Int?
    
    /// Index in Item.all array
    var itemIndex: Int?
    
    /// Item's name
    let name: String?
    
    /// The collection of URLs to load item images from
    let pictures: [URL]?
    
    /// The item's current price
    let price: Double?
    
    /// The item URL to purchase
    let url: URL?
    
    /// The item vendor
    let vendor: String?
    
    // MARK: - Computed Properties
    /// If item name starts with vendor (brand) drop that brand and capitalize the first letter of remaining string
    var nameWithoutVendor: String? {
        guard let name = name?.lowercased() else { return nil }
        guard let vendor = vendor?.lowercased(), name.starts(with: vendor) else { return name }
        return name.dropFirst(vendor.count).trimmingCharacters(in: .whitespacesAndNewlines).firstCapitalized
    }
    
    // MARK: - Methods
    /// Clears all items
    static func removeAll() {
        all.removeAll()
    }
}
