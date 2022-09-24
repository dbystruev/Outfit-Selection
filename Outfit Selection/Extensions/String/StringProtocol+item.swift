//
//  StringProtocol+item.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 17.11.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

extension StringProtocol {
    /// Assume self is item ID and return optional item with this ID
    var item: Item? {
        Items.byID[String(self)]
    }
}
