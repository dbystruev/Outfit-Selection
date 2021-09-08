//
//  Collection+all.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 06.09.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import Foundation

extension Collection {
    /// All collections created by the user
    static var _all: [Collection]?
    
    static var all: [Collection] {
        get { _all ?? [] }
        set {
            guard _all?.count != newValue.count else { return }
            _all = newValue
            save()
        }
    }
}

// MARK: - User Defaults
extension Collection {
    // MARK: - Static Constants
    /// User defaults key
    static let userDefaultsKey = "GetOutfitCollectionKey"
    
    // MARK: - Methods
    /// Load wishlist from user defaults
    static func load() {
        guard let data = UserDefaults.standard.object(forKey: userDefaultsKey) as? Data else {
            debug("WARNING: Can't find data from user defaults for key \(userDefaultsKey)")
            return
        }
        
        guard let collections = try? PList.decoder.decode([Collection].self, from: data) else {
            debug("WARNING: Can't decode \(data) from user defaults to [Collection] for key \(userDefaultsKey)")
            return
            
        }
        
        _all = collections
    }
    
    /// Save wishlist to user defaults
    static func save() {
        guard let data = try? PList.encoder.encode(all) else {
            debug("WARNING: Can't encode \(all.count) collections for key \(userDefaultsKey)")
            return
        }
        
        UserDefaults.standard.set(data, forKey: userDefaultsKey)
    }
}
