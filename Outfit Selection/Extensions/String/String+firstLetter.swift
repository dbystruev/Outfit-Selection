//
//  String+firstLetter.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 27.02.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//
//  https://www.hackingwithswift.com/example-code/strings/how-to-capitalize-the-first-letter-of-a-string

import Foundation

extension String {
    /// Capitalize only the first letter in the string, not in each word as in capitalized
    var capitalizingFirstLetter: String {
        prefix(1).capitalized + dropFirst()
    }
    
    /// Decapitalize only the first letter in the string
    var decapitalizingFirstLetter: String {
        prefix(1).lowercased() + dropFirst()
    }
}
