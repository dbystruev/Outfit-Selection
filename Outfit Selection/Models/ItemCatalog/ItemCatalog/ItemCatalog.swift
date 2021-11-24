//
//  ItemCatalog.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 04.10.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

/// Base calss for collection and wishlist item catalogs
class ItemCatalog: Codable {
    // MARK: - Types
    enum CodingKeys: String, CodingKey {
        case itemIDs = "item_ids"
        case kind
    }
    
    /// Type (kind) of items
    enum Kind: Int, Codable, CustomStringConvertible {
        case collection
        case item
        case outfit
        
        // MARK: - CustomStringConvertible
        var description: String {
            switch self {
                
            case .collection:
                return ".collection"
                
            case .item:
                return ".item"
                
            case .outfit:
                return ".outfit"
            }
        }
    }
    
    // MARK: - Stored Properties
    /// Kind (type) of the items
    let kind: Kind
    
    /// The list of item IDs
    var itemIDs: [String]
    
    /// The dictionary of items (or single item in case of .item type)
    var items: [String: Item] = [:]
    
    // MARK: - Computed Properties
    /// The first item of the items array
    var item: Item? { items.values.first }
    
    /// The set of items IDs
    var itemsIdSet: Set<String> { Set(itemIDs)}
    
    /// Price of all items combined
    var price: Double {
        items.values.reduce(0) { $0 + $1.price }
    }
    
    // MARK: - Init
    init(kind: Kind, itemIDs: [String]) {
        self.kind = kind
        self.itemIDs = itemIDs
        
        updateItems()
    }
    
    // MARK: - Methods
    /// Update all items vendor names to full versions
    /// - Parameter fullVendorNames: the dictionary with short : full vendor names
    func updateVendorNames(with fullVendorNames: [String: String]) {
        items.forEach {
            $0.value.updateVendorName(with: fullVendorNames)
            debug(items[$0.key], fullVendorNames)
        }
    }
    
    // MARK: - Decodable
    required init(from decoder: Decoder) throws {
        // Get values from the container
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        // Decode all properties
        kind = try values.decode(Kind.self, forKey: .kind)
        itemIDs = try values.decode([String].self, forKey: .itemIDs)
        
        // Init items with given item IDs
        updateItems()
    }
    
    /// Update items with given item IDs
    /// - Parameter itemIDs: item IDs to init items from
    func updateItems() {
        // Set already loaded items
        itemIDs.forEach {
            guard let item = Items.byID[$0] else { return }
            items[$0] = item
        }
        
        // Load new collection items not present in the global items
        let newItemIDs = itemIDs.filter { items[$0] == nil }
        
        NetworkManager.shared.getItems(newItemIDs) { newItems in
            // Append new items loaded from the server
            let newItems = newItems ?? []
            Items.append(contentsOf: newItems)
            newItems.forEach { self.items[$0.id] = $0 }
            
            // Remove item IDs not present in items
            self.itemIDs = self.itemIDs.filter { self.items[$0] != nil }
        }
    }
    
    // MARK: - Encodable
    func encode(to encoder: Encoder) throws {
        // Create encode container
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        // Encode properties
        try container.encode(itemIDs, forKey: .itemIDs)
        try container.encode(kind, forKey: .kind)
    }
}
