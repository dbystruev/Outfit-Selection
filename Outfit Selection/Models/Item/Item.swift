//
//  Item.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 26.10.2020.
//  Copyright © 2020 Denis Bystruev. All rights reserved.
//

import Foundation

struct Item: Encodable, Hashable {
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
    /// Dislikes given item in Item.all
    /// - Parameter item: the item to be disliked
    static func dislike(_ item: Item?) {
        guard let itemIndex = item?.itemIndex else { return }
        guard let index = Item.all.firstIndex(where: { $0.itemIndex == itemIndex }) else { return }
        Item.all[index].disliked = true
    }
    
    /// Clears all items
    static func removeAll() {
        all.removeAll()
    }
    
    // MARK: - Stored Properties
    /// Item's id
    let id: String?
    
    /// Item's category id
    let categoryId: Int?
    
    /// Whether an item has been disliked
    var disliked = false
    
    /// Index in Item.all array
    var itemIndex: Int?
    
    /// Date and time when offer was last modified
    var modifiedTime: Date?
    
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
        case categoryId = "category_id"
        case id
        case modifiedTime = "modified_time"
        case name
        case oldPrice = "old_price"
        case pictures
        case price
        case url
        case vendor
    }
    
    // MARK: - Computed Properties
    var modifiedTimestamp: String? {
        get {
            guard let modifiedTime = modifiedTime else { return nil }
            return Timestamp.formatter.string(from: modifiedTime)
        }
        set {
            guard let newValue = newValue else {
                modifiedTime = nil
                return
            }
            
            modifiedTime = Timestamp.formatter.date(from: newValue)
        }
    }
    
    /// If item name starts with vendor (brand) drop that brand and capitalize the first letter of remaining string
    var nameWithoutVendor: String? {
        guard let name = name?.lowercased() else { return nil }
        guard let vendor = vendor?.lowercased(), name.starts(with: vendor) else { return name }
        return name.dropFirst(vendor.count).trimmingCharacters(in: .whitespacesAndNewlines).capitalizingFirstLetter
    }
    
    /// Non-optional time for sorting operations
    var time: TimeInterval { (modifiedTime ?? Date(timeIntervalSince1970: 0)).timeIntervalSinceReferenceDate }
    
    // MARK: - Methods
    /// Set item's wishlist property to true or false
    /// - Parameter value: the value to set the wishlist property to, true by default
    func setWishlisted(to value: Bool = true) {
        guard let itemIndex = itemIndex else { return }
        Item.all[itemIndex].wishlisted = value
    }
}
