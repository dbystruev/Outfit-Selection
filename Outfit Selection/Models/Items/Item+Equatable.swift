//
//  Item+Equatable.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 21.09.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

extension Item: Equatable {
    static func == (lhs: Item, rhs: Item) -> Bool { lhs.id == rhs.id }
}
