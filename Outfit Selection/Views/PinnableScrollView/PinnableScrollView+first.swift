//
//  PinnableScrollView+first.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 19.11.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

extension PinnableScrollView {
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
        itemIDs.first
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
    func items(with IDs: [String]) -> [Item] {
        itemIDs(with: IDs).compactMap { Items.byID[$0] }
    }
}
