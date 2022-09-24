//
//  String+shortVendorName.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 06.10.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

extension String {
    /// Converts to lowercase and keeps only ASCII letters and digits
    /// Examples:
    ///     A-COLD-WALL* -> acoldwall
    var shorted: String {
        lowercased().filter { $0.isASCII && ($0.isLetter || $0.isDigit) }
    }
}
