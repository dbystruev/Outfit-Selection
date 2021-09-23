//
//  Character+isDigit.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 24.08.2020.
//
extension Character {
    var isDigit: Bool {
        "0"..."9" ~= self
    }
}
