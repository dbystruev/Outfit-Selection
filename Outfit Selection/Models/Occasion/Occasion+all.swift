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
    static var all: [Int: Occasion] = [:]
    
    // MARK: - Computed Properties
    /// The labels of all occasions
    static var labels: [String] { all.values.map({ $0.label })}
    /// The names of all occasions
    static var names: [String] { all.values.map({ $0.name })}
    
    /// The list of selected occasions
    static var selected: [Occasion] { all.values.filter { $0.isSelected }}
    
    /// The ids of selected occasions
    static var selectedIDs: [Int] { selected.map { $0.id }}
    
    /// The labels of selected occasions
    static var selectedLabels: [String] { selected.map { $0.label }}
    
    /// The names of selected occasions
    static var selectedNames: [String] { selected.map { $0.name }}
    
    /// The list of unselected occasions
    static var unselected: [Occasion] { all.values.filter { !$0.isSelected }}
}
