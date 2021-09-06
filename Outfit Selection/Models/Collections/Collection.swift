//
//  Collection.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 06.09.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

struct Collection {
    // MARK: - Stored Properties
    /// Collection items
    var items: [CollectionItem]
    
    /// Collection name
    var name: String
    
    // MARK: - Methods
    /// Returns true or false depending on whether collection constains a collection item
    /// - Parameter item: collection item to check for
    /// - Returns: true or false depending on result
    func contains(_ item: CollectionItem) -> Bool {
        items.contains(item)
    }
    
    /// Returns true or false depending on whether collection contains an item
    /// - Parameter item: an item to check for
    /// - Returns: true or false depending on result
    func contains(_ item: Item) -> Bool {
        contains(CollectionItem(item: item))
    }
    
    /// Returns true or false depending on whether collection contains a look
    /// - Parameter look: collection items to check for
    /// - Returns: true or false depending on result
    func contains(_ look: [Item]) -> Bool {
        contains(CollectionItem(look: look))
    }
}
