//
//  CollectionItem+Equatable.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 06.09.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

extension CollectionItem: Equatable {
    static func == (lhs: CollectionItem, rhs: CollectionItem) -> Bool {
        lhs.kind == rhs.kind && Set(lhs.itemIDs) == Set(rhs.itemIDs)
    }
}
