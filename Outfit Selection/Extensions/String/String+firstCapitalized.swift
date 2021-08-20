//
//  String+firstCapitalized.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 27.02.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import Foundation

extension String {
    /// Capitalize only the first letter in the string, not in each word as in capitalized
    var firstCapitalized: String {
        guard let firstLetter = first?.uppercased() else { return self }
        return firstLetter + dropFirst()
    }
}
