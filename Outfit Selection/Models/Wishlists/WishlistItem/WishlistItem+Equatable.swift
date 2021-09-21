//
//  WishlistItem+Equatable.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 22.09.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import Foundation

extension WishlistItem: Equatable {
    static func == (lhs: WishlistItem, rhs: WishlistItem) -> Bool {
        lhs.gender == rhs.gender && lhs.itemsIdSet == rhs.itemsIdSet && lhs.kind == rhs.kind
    }
}
