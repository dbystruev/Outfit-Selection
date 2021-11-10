//
//  Swift.Collection+items.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 29.10.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

extension Swift.Collection where Element: StringProtocol  {
    /// Get items from IDs
    var items: Items { compactMap { Items.byID[String($0)] }}
}
