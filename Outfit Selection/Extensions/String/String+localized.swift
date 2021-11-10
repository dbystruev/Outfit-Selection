//
//  String+localized.swift
//  Tadam
//
//  Created by Denis Bystruev on 29.03.2021.
//

import Foundation

postfix operator ~
extension String {
    /// String represented as NSLocalizedString
    var localized: String {
        NSLocalizedString(self, comment: self)
    }
    
    /// Shorter version of .localized — string represented as NSLocalizedString
    /// - Returns: localized string
    static postfix func ~ (_ string: String) -> String {
        string.localized
    }
}
