//
//  Gender.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 26.10.2020.
//  Copyright © 2020 Denis Bystruev. All rights reserved.
//

/// Gender selected by the user
enum Gender: String {
    // MARK: - Static Properties
    /// Currently selected gender
    static var current: Gender?
    
    // MARK: - Cases
    case female
    case male
    case other = "non-binary"
}

// MARK: - Case Iterable
extension Gender: CaseIterable {}
