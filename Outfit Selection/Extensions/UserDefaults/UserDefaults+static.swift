//
//  UserDefaults+static.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 19.10.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//
//  https://www.avanderlee.com/swift/property-wrappers/

import Foundation

extension UserDefaults {
    
    /// True if user has seen onboarding
    @UserDefault(key: "GetOutfitHasSeenAppIntroduction", defaultValue: false)
    static var hasSeenAppIntroduction: Bool
}
