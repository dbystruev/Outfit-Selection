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
    /// - Returns: loaded collections
    static func load() -> [Gender: [Collection]] {
        guard let data = UserDefaults.standard.object(forKey: userDefaultsKey) as? Data else {
            debug("WARNING: Can't find data from user defaults for key \(userDefaultsKey)")
            return [:]
        }
        
        guard let genderCollections = try? PList.decoder.decode([Gender: [Collection]].self, from: data) else {
            debug(
                "WARNING: Can't decode \(data)",
                "from user defaults to \([Gender: [Collection]].self)",
                "for key \(userDefaultsKey)"
            )
            return [:]
            
        }
        
        return genderCollections
    }
    
    /// Save all collections to user defaults
    /// - Parameter genderCollections: dictionary of collections listed by gender
    static func save(_ genderCollections: [Gender: [Collection]]) {
        guard let data = try? PList.encoder.encode(genderCollections) else {
            debug(
                "WARNING: Can't encode \(genderCollections.count)",
                "to \([Gender: [Collection]].self) gender collections",
                "for key \(userDefaultsKey)"
            )
            return
        }
        
        UserDefaults.standard.set(data, forKey: userDefaultsKey)
    }
}
