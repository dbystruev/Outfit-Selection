//
//  UserDefault+propertyWrapper.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 19.10.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//
//  https://www.avanderlee.com/swift/property-wrappers/

import Foundation

@propertyWrapper
struct UserDefault<Value> {
    let key: String
    let defaultValue: Value
    var container: UserDefaults = .standard
    
    var wrappedValue: Value {
        get {
            container.object(forKey: key) as? Value ?? defaultValue
        }
        set {
            container.set(newValue, forKey: key)
        }
    }
}
