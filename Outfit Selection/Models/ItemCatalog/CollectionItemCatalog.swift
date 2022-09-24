//
//  CollectionItemCatalog.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 06.09.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

final class CollectionItemCatalog: ItemCatalog {    
    // MARK: - Init
    convenience init?(_ item: Item?) {
        guard let item = item else { return nil }
        self.init(kind: .item, itemIDs: [item.id])
    }

    convenience init?(_ outfit: Items?) {
        guard let outfit = outfit, !outfit.isEmpty else { return nil }
        self.init(kind: .outfit, itemIDs: outfit.IDs)
    }
}
