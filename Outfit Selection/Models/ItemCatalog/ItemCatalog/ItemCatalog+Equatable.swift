//
//  ItemCatalog+Equatable.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 04.10.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

extension ItemCatalog: Equatable {
    static func == (lhs: ItemCatalog, rhs: ItemCatalog) -> Bool {
        lhs.kind == rhs.kind && lhs.itemsIdSet == rhs.itemsIdSet
    }
}
