//
//  Occasion+Comparable.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 09.09.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

extension Occasion: Comparable {
    static func < (lhs: Occasion, rhs: Occasion) -> Bool {
        lhs.isSelected && !rhs.isSelected       // selected occasions should be listed first
        || lhs.isSelected == rhs.isSelected     // if both are selected or both are unselected...
        && (
            lhs.name < rhs.name                 // ... then first sort by name
            || lhs.name == rhs.name             // if names are equal...
            && lhs.label < rhs.label            // ...then sort by labels
        )
    }
    
    static func == (lhs: Occasion, rhs: Occasion) -> Bool { lhs.id == rhs.id }
}
