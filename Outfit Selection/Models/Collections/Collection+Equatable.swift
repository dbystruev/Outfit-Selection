//
//  Collection+Equatable.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 01.10.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

extension Collection: Equatable {
    static func == (lhs: Collection, rhs: Collection) -> Bool {
        lhs.itemCount == rhs.itemCount
        && lhs.gender == rhs.gender
        && Set(lhs.items.map { $0.id }) == Set(rhs.items.map { $0.id })
    }
}
