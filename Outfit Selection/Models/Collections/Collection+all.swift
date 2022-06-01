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
    
    static func append(_ item: Item, index: Int) {
        debug(genderCollections)
        
        // Check gender are present already
        guard let gender = Gender.current else { return }
        guard let collection = genderCollections[gender]?.remove(at: index) else { return }
        
        //TODO: ADD item to Collection
        //collection.append(item)
        append(collection)
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
}
