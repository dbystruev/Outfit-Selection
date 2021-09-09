//
//  Occasion+Comparable.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 09.09.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

extension Occasion: Comparable {
    static func < (lhs: Occasion, rhs: Occasion) -> Bool {
        lhs.isSelected && !rhs.isSelected || lhs.isSelected == rhs.isSelected && lhs.name < rhs.name
    }
    
    static func == (lhs: Occasion, rhs: Occasion) -> Bool {
        lhs.name == rhs.name
    }
}
