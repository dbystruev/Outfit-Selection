//
//  Occasion.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 09.09.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import Foundation

struct Occasion: Codable {
    
    // MARK: - Properties
    /// The name of the occasion
    let name: String
    
    /// Flag showing if occasion is selected by the user
    var isSelected = false
    
    // MARK: - Init
    /// Constructor for occasion
    /// - Parameters:
    ///   - name: the name of the occasion
    ///   - isSelected: whether the occasion is selected by the user, false by default
    init(_ name: String, isSelected: Bool = false) {
        self.name = name
        self.isSelected = isSelected
    }
}
