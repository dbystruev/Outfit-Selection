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
    
    /// The maximum number of items for all categories, should be divisible by Category.all.count, each category has maxCount / Category.all.count items
    static let maxCount = 1000
    
    // MARK: - Static Methods
    /// Appends items to Item.all. Mimics generic collection's method append(contentsOf:) while saving current index in itemIndex property of each item
    /// - Parameter newItems: collection of new items to be added to the Item.all
    static func append(contentsOf newItems: [Item]) {
        for var newItem in newItems {
            newItem.itemIndex = all.count
            all.append(newItem)
        }
    }
    
    // MARK: - Properties
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
}
