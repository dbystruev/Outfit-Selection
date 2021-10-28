//
//  WishlistItemCatalog+CustomStringConvertible.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 06.10.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

extension WishlistItemCatalog: CustomStringConvertible {
    var description: String {
        "\(gender) \(kind) \(name ?? "nil"): \(itemIDs.count) \(itemIDs)"
    }
}
