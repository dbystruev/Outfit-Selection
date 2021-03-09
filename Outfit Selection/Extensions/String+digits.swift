//
//  String+digits.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 24.08.2020.
//
extension String {
    /// Returns only digits 0...9 dropping everyting else
    var digits: String {
        filter { $0.isDigit }
    }
    
    /// Keep only the given number of digits
    /// - Parameter limit: the number of digits to keep
    /// - Returns: string of digits with length no more than limit
    func digits(_ limit: Int) -> String {
        // Keep only digits from "0" to "9"
        let digits = self.digits
        
        // Drop the digits above the given limit
        return String(digits.dropLast(max(0, digits.count - limit)))
    }
    
    /// True if the string has any digits
    var hasDigits: Bool {
        !digits.isEmpty
    }
}
