//
//  String+letters.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 01.03.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

extension String {
    /// Return only letters, lowercased
    var lowercasedLetters: String {
        lowercased().filter { $0.isLowercase }
    }
    
    /// Return only letters, uppercased
    var uppercasedLetters: String {
        uppercased().filter { $0.isUppercase }
    }
}
