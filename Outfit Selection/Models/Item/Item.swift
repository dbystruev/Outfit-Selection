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
    
    // MARK: - Static Methods
    /// Clears all items
    static func removeAll() {
        all.removeAll()
    }
    
    // MARK: - Stored Properties
    /// Item's category id
    let categoryId: Int?
    
    /// Index in Item.all array
    var itemIndex: Int?
    
    /// Time when offer was last modified
    let modifiedTime: TimeInterval? // since 1970.01.01
    
    /// Item's name
    let name: String?
    
    /// The item's previous price
    let oldPrice: Double?
    
    /// The collection of URLs to load item images from
    let pictures: [URL]?
    
    /// The item's current price
    let price: Double?
    
    /// The item URL to purchase
    let url: URL?
    
    /// The item vendor
    let vendor: String?

    /// True if item is in any wishlist, false otherwise (default)
    var wishlisted: Bool? = false
    
    enum CodingKeys: String, CodingKey {
        case categoryId
//        case itemIndex
        case modifiedTime = "modified_time"
        case name
        case oldPrice = "oldprice"
        case pictures
        case price
        case url
        case vendor
//        case wishlisted
    }
    
    // MARK: - Computed Properties
    /// If item name starts with vendor (brand) drop that brand and capitalize the first letter of remaining string
    var nameWithoutVendor: String? {
        guard let name = name?.lowercased() else { return nil }
        guard let vendor = vendor?.lowercased(), name.starts(with: vendor) else { return name }
        return name.dropFirst(vendor.count).trimmingCharacters(in: .whitespacesAndNewlines).firstCapitalized
    }
    
    /// Non-optional time for sorting operations
    var time: TimeInterval { modifiedTime ?? Date(timeIntervalSince1970: 0).timeIntervalSinceReferenceDate }
    
    // MARK: - Methods
    /// Set item's wishlist property to true or false
    /// - Parameter value: the value to set the wishlist property to, true by default
    func setWishlisted(to value: Bool = true) {
        guard let itemIndex = itemIndex else { return }
        Item.all[itemIndex].wishlisted = value
    }
}
