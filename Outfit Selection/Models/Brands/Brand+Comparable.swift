//
//  Brand+Comparable.swift
//  Outfit Selection
//
//  Created by Evgeniy Goncharov on 05.03.2022.
//  Copyright © 2022 Denis Bystruev. All rights reserved.
//


extension Brand: Comparable {
    
    static func < (lhs: Brand, rhs: Brand) -> Bool {
        let lhsNil = lhs.image == nil
        let rhsNil = rhs.image == nil
        return !lhsNil && rhsNil
        || lhsNil == rhsNil && lhs.name.lowercased() < rhs.name.lowercased()
    }
    
    static func == (lhs: Brand, rhs: Brand) -> Bool {
        lhs.id == rhs.id && lhs.id != nil ||
        lhs.name.lowercased() == rhs.name.lowercased()
    }
}
