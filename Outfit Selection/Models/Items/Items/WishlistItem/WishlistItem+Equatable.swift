//
//  WishlistItem+Equatable.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 22.09.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

// MARK: - Equatable
extension WishlistItems {
    static func == (lhs: WishlistItems, rhs: WishlistItems) -> Bool {
        lhs.gender == rhs.gender
            && lhs.itemsIdSet == rhs.itemsIdSet
            && lhs.kind == rhs.kind
    }
}
