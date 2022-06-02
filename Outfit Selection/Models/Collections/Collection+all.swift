//
//  Collection+all.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 06.09.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import Foundation

extension Collection {
    // MARK: - Static Stored Properties
    /// Lists of collections for all genders
    private static var genderCollections: [Gender: [Collection]] = [:]
    
    // MARK: - Static Computed Properties
    /// All collections for current gender
    static var all: [Collection] {
        guard let gender = Gender.current else { return [] }
        return genderCollections[gender] ?? []
    }
    
    /// Last added collection for current gender
    static var last: Collection? {
        all.last
    }
    
    // MARK: - Static Methods
    /// Add collection for given gender
    /// - Parameters:
    ///   - collection: the collection to add
    static func append(_ collection: Collection) {
        // Save collections for all genders to user defaults when finished
        defer { save(genderCollections) }
        
        // Check if collections for gender are present already
        let gender = collection.gender
        guard var collections = genderCollections[gender] else {
            // If not present — create new collection list for its gender
            genderCollections[gender] = [collection]
            return
        }
        
        // If present — add new collection to existing gender
        collections.append(collection)
        genderCollections[gender] = collections
    }
    
    /// Append new item into collection
    /// - Parameters:
    ///   - item: item for append
    ///   - index: index collection
    static func append(_ item: Item, index: Int) {
        
        // Save collections for all genders to user defaults when finished
        defer { save(genderCollections) }
        
        // Check gender are present already
        guard let gender = Gender.current else { return }
        
        // Remove collection into Collections
        guard let collection = genderCollections[gender]?.remove(at: index) else {
            debug("ERROR: Can't get collection for index", index )
            return
        }
        
        // Append new item into collection
        collection.append(CollectionItemCatalog(item))
        guard var collections = genderCollections[gender] else {

            // If not present — create new collection list for its gender
            genderCollections[gender] = [collection]
            return
        }
        
        // Insert new collection into collections
        collections.insert(collection, at: index)
        
        // Set new collections into genderCollections
        genderCollections[gender] = collections
    }
    
    /// Remove all collections for current gender
    static func removeAll() {
        guard let gender = Gender.current else { return }
        genderCollections[gender]?.removeAll()
    }
    
    /// Remove collection for current gender with name
    static func remove(name: String) {
        // Save collections for all genders to user defaults when finished
        defer { save(genderCollections) }
        
        // Check gender are present already
        guard let gender = Gender.current else { return }
        // Remove collection
        genderCollections[gender]?.removeAll(where: { $0.name == name })
    }
    
    /// Remove item from collection
    /// - Parameters:
    ///   - item: item for remove
    ///   - index: index collectionremove
    static func remove(_ item: Item, index: Int) {
        
        // Save collections for all genders to user defaults when finished
        defer { save(genderCollections) }
        
        // Check gender are present already
        guard let gender = Gender.current else { return }
        
        // Remove collection into Collections
        guard let collection = genderCollections[gender]?.remove(at: index) else {
            debug("ERROR: Can't get collection for index", index )
            return
        }
        
        // Get items from gender collections at index
        var items = collection.items
        items.removeAll(where: { $0.id == item.id })
        
        // Clear collection
        collection.removeAll()
        
        // Append new item into collection
        collection.append(CollectionItemCatalog(items))
        
        guard var collections = genderCollections[gender] else {
            // If not present — create new collection list for its gender
            genderCollections[gender] = [collection]
            return
        }
        
        // Insert new collection into collections
        collections.insert(collection, at: index)
        
        // Set new collections into genderCollections
        genderCollections[gender] = collections
    }
    
    /// Remove last collection for current gender
    static func removeLast() {
        guard let gender = Gender.current else { return }
        genderCollections[gender]?.removeLast()
    }
    
    /// Save collections for all genders to user defaults
    static func save() {
        save(genderCollections)
    }
    
    /// Update collections
    /// - Parameters:
    ///   - oldName: old name collection
    ///   - newName: new name collection
    static func update(oldName: String, newName: String) {
        guard let gender = Gender.current else { return }
        guard let collection = genderCollections[gender]?.first(where: { $0.name == oldName }) else {
            debug("ERROR: Can't get collection witn name", oldName )
            return
        }
        remove(name: oldName)
        collection.name = newName
        append(collection)
    }
    
    /// Update items into collection
    /// - Parameters:
    ///   - item: an item for replace
    ///   - newItem: a new item for replace
    ///   - index: index for collection
    static func update(item: Item, newItem: Item, index: Int) {
        // Save collections for all genders to user defaults when finished
        defer { save(genderCollections) }
        
        // Check gender are present already
        guard let gender = Gender.current else { return }
        
        // Remove collection into Collections
        guard let collection = genderCollections[gender]?.remove(at: index) else {
            debug("ERROR: Can't get collection for index", index )
            return
        }
        
        // Get items from collection
        var items = collection.items
        
        // Replace item for new item
        items.replaceElement(item, withElement: newItem)
        
        // Clearn all items into collection
        collection.removeAll()
        
        // Append new items into collection
        collection.append(CollectionItemCatalog(items))
        guard var collections = genderCollections[gender] else {

            // If not present — create new collection list for its gender
            genderCollections[gender] = [collection]
            return
        }
        
        // Insert new collection into collections
        collections.insert(collection, at: index)
        
        // Set new collections into genderCollections
        genderCollections[gender] = collections
    }
}
