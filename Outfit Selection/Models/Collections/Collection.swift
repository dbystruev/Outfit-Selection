//
//  Collection.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 06.09.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

class Collection: Codable {
    // MARK: - Stored Properties
    /// Collection items
    private var collectionItems: [CollectionItem] = []
    
    /// Collection name
    let name: String
    
    // MARK: - Computed Propeties
    var count: Int { collectionItems.count }
    var isEmpty: Bool { collectionItems.isEmpty }
    var items: [Item] {
        collectionItems.flatMap { $0.items }
    }
    
    // MARK: - Init
    /// Initialize a collection with empty set of items and given name
    /// - Parameter name: the name of the collection
    init(_ name: String) {
        self.name = name
    }
    
    // MARK: - Methods
    func append(_ item: CollectionItem?) {
        guard let item = item else {
            debug("WARNING: item is nil")
            return
        }
        collectionItems.append(item)
    }
    
    /// Returns true or false depending on whether collection constains a collection item
    /// - Parameter item: collection item to check for
    /// - Returns: true or false depending on result
    func contains(_ item: CollectionItem) -> Bool {
        collectionItems.contains(item)
    }
    
    /// Returns true or false depending on whether collection contains an item
    /// - Parameter item: an item to check for
    /// - Returns: true or false depending on result
    func contains(_ item: Item) -> Bool {
        guard let collectionItem = CollectionItem(item) else { return false }
        return contains(collectionItem)
    }
    
    /// Returns true or false depending on whether collection contains a look
    /// - Parameter look: collection items to check for
    /// - Returns: true or false depending on result
    func contains(_ outfit: [Item]) -> Bool {
        guard let collectionOutfit = CollectionItem(outfit) else { return false }
        return contains(collectionOutfit)
    }
    
    /// Removes given collection item from the collection
    /// - Parameter item: collection item to be removed
    func remove(_ item: CollectionItem) {
        collectionItems.removeAll { $0 == item }
    }
}
