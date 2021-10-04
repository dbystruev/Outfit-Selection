//
//  Items+Equatable.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 04.10.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

extension Items: Equatable {
    static func == (lhs: Items, rhs: Items) -> Bool {
        lhs.kind == rhs.kind && lhs.itemsIdSet == rhs.itemsIdSet
    }
}
