//
//  Collection+unique.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 14.10.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

extension Swift.Collection where Element: Equatable {
    /// Return indices of unique elements
    var uniqueIndices: [Self.Index] {
        indices.filter({ index in firstIndex(where: { $0 == self[index] }) == index })
    }
    
    /// Return unique elements
    var unique: [Element] {
        uniqueIndices.map { self[$0] }
    }
}
