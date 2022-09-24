//
//  ItemSearchable.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 22.11.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

/// Protocol which contains items property and adds methods to search for them
protocol ItemSearchable {
    /// The items found in the object
    var items: Items { get }
}

extension ItemSearchable {
    /// Item IDs of each of the items
    var itemIDs: [String] { items.IDs }
    
    /// Find first item with ID from the list of given IDs, return nil if not found
    /// - Parameter IDs: item IDs to search for
    /// - Returns: first item with given IDs or nil if not found
    func firstItem(with IDs: [String]) -> Item? {
        items(with: IDs).first
    }
    
    /// Find first item with ID matching the list of given IDs, return nil if not found
    /// - Parameter IDs: item IDs to search for
    /// - Returns: first item IDs matching given IDs or nil if not found
    func firstItemID(with IDs: [String]) -> String? {
        itemIDs(with: IDs).first
    }
    
    /// Find items with IDs from the list of given IDs present in the scroll view
    /// - Parameter IDs: item IDs to search for
    /// - Returns: the list of items with given IDs
    func itemIDs(with IDs: [String]) -> [String] {
        let itemIDs = itemIDs
        return IDs.filter { itemIDs.contains($0) }
    }
    
    /// Find items with IDs from the list of given IDs present in the scroll view
    /// - Parameter IDs: item IDs to search for
    /// - Returns: the list of items with given IDs
    func items(with IDs: [String]) -> Items {
        itemIDs(with: IDs).compactMap { Items.byID[$0] }
    }
}
