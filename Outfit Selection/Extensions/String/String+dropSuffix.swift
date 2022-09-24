//
//  String+dropSuffix.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 23.09.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

extension String {
    /// Drops the suffix found in string
    /// - Parameter suffix: the suffix to search for
    /// - Returns: string without the suffix
    func drop(suffix: String) -> String {
        guard reversed().starts(with: suffix.reversed()) else { return self }
        return String(dropLast(suffix.count))
    }
}
