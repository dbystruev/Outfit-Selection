//
//  Gender+UserDefaults.swift
//  Outfit Selection
//
//  Created by Evgeniy Goncharov on 16.04.2022.
//  Copyright © 2022 Denis Bystruev. All rights reserved.
//

import Foundation

// MARK: - User Defaults
extension Gender {
    // MARK: - Methods
    /// Load gender from user defaults
    static func restore() {
        // Get data from UserDefaults currentGender
        guard let data = UserDefaults.currentGender else {
            debug("WARNING: Can't find gender data in user defaults")
            return
        }
        // Get current gender form UserDefault data
        guard let currentGender = try? JSON.decoder.decode(Gender.self, from: data) else {
            debug("WARNING: Can't decode gender \(data) from user defaults to \(Gender.self)")
            return
        }
        // Restore gender fron userDefualts
        Gender.current = currentGender
    }
    
    /// Save gender to user defaults
    static func save() {
        let currentGender = Gender.current
        guard let data = try? JSON.encoder.encode(currentGender) else {
            debug("WARNING: Can't encode gender from user defaults")
            return
        }
        //debug("DEBUG: Saving \(data) to user defaults gender")
        UserDefaults.currentGender = data
    }
}
