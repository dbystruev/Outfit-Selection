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
    private(set) static var all = [Item]()
    static let maxCount = 24
    
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
    let categoryId: Int?
    
    /// Index in Item.all array
    var itemIndex: Int?
    
    let name: String?
    let pictures: [URL]?
    let price: Double?
    let url: URL?
    
}
