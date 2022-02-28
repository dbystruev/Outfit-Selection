//
//  FeedItemViewController+UICollectionViewDataSource.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 27.08.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import UIKit

// Load current offset index
let currentOffset = Globals.Feed.currentOffset

extension FeedItemViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count //Int.max
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Dequeue or create feed item collection view cell
        let itemItem: FeedItemCollectionCell = {
            
            // Currrent index item from collectionView
            let indexCell = indexPath.sorted()[1]
            
            // Check index items
            if indexCell > items.count / 2  && !itemsDownloaded {
                
                debug(indexCell)
                
                // Limit items for download
                let limit = items.count > 500 ? (items.count * 2) : (items.count * 4)
                
                // Switch to true and wait download all items
                itemsDownloaded.toggle()
                
                // Get and add new items into items
                getNewItems(offset: items.count, limit: limit)
            }
            
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: FeedItemCollectionCell.reuseId,
                for: indexPath
            )
            guard let itemCell = cell as? FeedItemCollectionCell else {
                debug("WARNING: Can't cast \(cell) as \(FeedItemCollectionCell.self)")
                let itemCell = FeedItemCollectionCell()
                return itemCell
            }
            return itemCell
        }()
        
        // Configure the cell with matching item and return
        itemItem.configureContent(kind: kind, item: items[indexPath.row], isInteractive: true)
        
        // Set feed view controller as delegate for item button tapped
        let controllers = navigationController?.viewControllers
        let feedViewController = controllers == nil ? nil : controllers![safe: controllers!.count - 2]
        guard let delegate = feedViewController as? ButtonDelegate else {
            debug("WARNING: Can't set \(String(describing: feedViewController)) as \(ButtonDelegate.self)")
            return itemItem
        }
        itemItem.delegate = delegate
        return itemItem
    }
    
    /// Download new items an add to current collectionView
    /// - Parameters:
    ///   - offset: number offset for start get items
    ///   - limit: limit download items
    func getNewItems(offset:Int, limit: Int) {
        
        // All sections will need to be filtered by brands
        let brandManager = BrandManager.shared
        let brandNames = brandManager.selectedBrandNames
    
        debug(offset)
        
        // Categories should be limited for occasions
        let subcategoryIDs: [Int] = {
            if case let .occasions(id) = kind {
                return Occasions.byID[id]?.flatSubcategoryIDs.compactMap { $0 } ?? []
            } else {
                return []
            }
        }()
        
        // If feed type is sale get items with old prices set
        let sale = kind == .sale
        
        // Make parameters for get
        let parametrs = NetworkManager.shared.parameters(
            for: Gender.current,
               in: [],
               subcategoryIDs: subcategoryIDs,
               limited: limit,
               sale: sale,
               filteredBy: brandNames
        )
        
        // Request to get items from the API
        NetworkManager.shared.getItems(with: parametrs, offset: items.count) { items in
            
            // Check for self availability
            guard let items = items else {
                return
            }
            
            for item in items {
                
                // If contains current item in items
                guard !self.items.contains(item) else { continue }
                
                // Append item to collection view items
                self.items.append(item)
                
                // Set current items count to offset
                Globals.Feed.countOffset = self.items.count
            }
            
            debug(self.items.count)
            
            // Return to main thead
            DispatchQueue.main.async {
                
                // Reload data
                self.itemCollectionView.reloadData()
                
                // Switch to false
                self.itemsDownloaded.toggle()
            }
        }
    }
}
