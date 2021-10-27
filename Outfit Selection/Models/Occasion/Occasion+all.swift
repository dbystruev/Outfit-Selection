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
    static var all: [Int: Occasion] = [:] {
        didSet {
            byTitle.removeAll()
            titles.forEach { byTitle[$0] = with(title: $0) }
        }
    }
    
    /// All occasions by title
    static var byTitle: [String: [Occasion]] = [:]
    
    // MARK: - Computed Properties
    /// The set of labels of all occasions
    static var labels: Set<String> { Set(all.values.map({ $0.label }))}
    
    /// The set of names of all occasions
    static var names: Set<String> { Set(all.values.map({ $0.name }))}
    
    /// The list of selected occasions
    static var selected: [Occasion] { all.values.filter { $0.isSelected }}
    
    /// The ids of selected occasions
    static var selectedIDs: [Int] { selected.map { $0.id }}
    
    /// The set of labels of selected occasions
    static var selectedLabels: Set<String> { Set(selected.map { $0.label })}
    
    /// The set of names of selected occasions
    static var selectedNames: Set<String> { Set(selected.map { $0.name })}
    
    /// The set of titles (name: label) of selected occasions
    static var selectedTitles: Set<String> { Set(selected.map { $0.title })}
    
    /// The set of titles (name: label) of all occasions
    static var titles: Set<String> { Set(all.values.map { $0.title })}
    
    /// The list of unselected occasions
    static var unselected: [Occasion] { all.values.filter { !$0.isSelected }}
    
    // MARK: - Methods
    /// Select/deselect all occasions with given title
    /// - Parameters:
    ///   - title: the title to search for
    ///   - shouldSelect: true to select, false to unselect
    static func select(title: String, shouldSelect: Bool) {
        with(title: title).forEach { $0.isSelected = shouldSelect }
    }
    
    /// Return all occasions with given title
    /// - Parameter title: the title to look for
    /// - Returns: the list of occasions with the title
    static func with(title: String) -> [Occasion] {
        all.values.filter { $0.title == title }
    }
}
