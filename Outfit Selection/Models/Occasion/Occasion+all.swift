//
//  Occasion+all.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 09.09.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import Foundation

extension Occasion {
    
    // MARK: - Stored Properties
    /// All occasions, not selected by default
    static var all: [String: Occasion] = [:]
    
    // MARK: - Computed Properties
    /// The names of all occasions
    static var names: [String] { all.keys.map({ $0 }) }
    
    /// The list of selected occasions
    static var selected: [Occasion] { all.values.filter { $0.isSelected }}
    
    /// The names of selected occasions
    static var selectedNames: [String] { selected.map { $0.name }}
}
