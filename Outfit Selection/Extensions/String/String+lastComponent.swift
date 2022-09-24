//
//  String+lastComponent.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 17.11.2020.
//  Copyright © 2020 Denis Bystruev. All rights reserved.
//

extension String {
    /// Returns the last part of the string split by slash character "/"
    var lastComponent: String {
        lastComponent()
    }
    
    /// Returns the last part of the string split by given separating character
    /// - Parameter separator: the character which separates the parts of the string
    /// - Returns: the last part of the string
    func lastComponent(separator: Character = "/") -> String {
        String(split(separator: separator).last ?? "")
    }
}
