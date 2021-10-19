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
    // MARK: - Methods
    /// Load collections from user defaults
    static func restore() {
        guard let data = UserDefaults.collections else {
            debug("WARNING: Can't find saved collections in user defaults")
            return
        }
        
        guard let collections = try? PList.decoder.decode(Collections.self, from: data) else {
            debug(
                "WARNING: Can't decode \(data) for collections",
                "from user defaults to \([Collection].self)"
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
        let collections = genderCollections.values.flatMap { $0 }
        guard let data = try? PList.encoder.encode(collections) else {
            debug(
                "WARNING: Can't encode \(collections.count) collections",
                "to \(Collections.self) gender collections"            )
            return
        }
        
        UserDefaults.collections = data
    }
}
