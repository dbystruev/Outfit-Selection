//
//  Collections.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 01.10.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

typealias Collections = [Collection]

extension Collections {
    // MARK: - Computed Properties
    /// The number of all items in all collections
    var itemCount: Int { items.count }
    
    /// All items in all collections
    var items: Items { flatMap({ $0.items })}
}
