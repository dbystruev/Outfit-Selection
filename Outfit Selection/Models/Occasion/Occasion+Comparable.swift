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
        && lhs.title < rhs.title                // then sort by title (name: label)
    }
    
    static func == (lhs: Occasion, rhs: Occasion) -> Bool { lhs.id == rhs.id }
}
