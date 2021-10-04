//
//  Collection+UserDefaults.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 04.10.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import Foundation

// MARK: - User Defaults
extension Collection {
    // MARK: - Static Constants
    /// User defaults key
    static let userDefaultsKey = "GetOutfitCollectionKey"
    
    // MARK: - Methods
    /// Load collections from user defaults
    static func load() {
        guard let data = UserDefaults.standard.object(forKey: userDefaultsKey) as? Data else {
            debug("WARNING: Can't find data from user defaults for key \(userDefaultsKey)")
            return
        }
        
        guard let collections = try? PList.decoder.decode(Collections.self, from: data) else {
            debug(
                "WARNING: Can't decode \(data)",
                "from user defaults to \([Collection].self)",
                "for key \(userDefaultsKey)"
            )
            return
        }
        
        for collection in collections {
            Collection.append(collection)
        }
    }
    
    /// Save all collections to user defaults
    /// - Parameter genderCollections: dictionary of collections listed by gender
    static func save(_ genderCollections: [Gender: [Collection]]) {
        debug(genderCollections.keys, genderCollections.values)
        let collections = genderCollections.values.flatMap { $0 }
        guard let data = try? PList.encoder.encode(collections) else {
            debug(
                "WARNING: Can't encode \(collections.count)",
                "to \(Collections.self) gender collections",
                "for key \(userDefaultsKey)"
            )
            return
        }
        
        UserDefaults.standard.set(data, forKey: userDefaultsKey)
    }
}
