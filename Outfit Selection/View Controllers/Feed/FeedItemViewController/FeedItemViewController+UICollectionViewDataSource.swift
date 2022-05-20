//
//  FeedItemViewController+UICollectionViewDataSource.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 27.08.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import UIKit

// Load Content-Range
let contentRange = Globals.Feed.contentRange

// Count of tries to get an answer from the API server
let countTry = 2

// Load current offset index
let currentOffset = Globals.Feed.currentOffset

// Local count of tries to get an answer from API
var localCountTry = 0

// Load limit section in CollectionView
let limitSection = Globals.Feed.limitSection

// Limit for API call
let limitCellApi = Globals.Feed.limitCellApi

extension FeedItemViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        tabBarController?.selectedIndex == Globals.TabBar.index.wishlist ? items.count : Int.max
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // Dequeue or create feed item collection view cell
        let itemItem: FeedItemCollectionCell = {
            
            // Currrent index item from collectionView
            let indexCell = indexPath.sorted()[1]
            
            // Check index items
            if indexCell > items.count / Int(1.3) && !itemsDownloaded {
                
                debug(indexCell)
                
                if limitSection > items.count {
                    
                    // Switch to true and wait download all items
                    itemsDownloaded.toggle()
                    
                    // Get and add new items into items
                    getNewItems(offset: items.count, limit: limitCellApi)
                    
                } else {
                    
                    debug("INFO: Limit in section. Count items: \(items.count) Limit: \(limitSection)"   )
                }
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
        if 0 < items.count {
            itemItem.configureContent(kind: section, item: items[indexPath.row % items.count], isInteractive: true)
        } else {
            debug("WARNING: items.count is \(items.count)")
        }
        
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
    
    /// Download new items and add to current collectionView
    /// - Parameters:
    ///   - offset: number offset for start get items
    ///   - limit: limit download items
    func getNewItems(offset:Int, limit: Int) {
        
        // All sections will need to be filtered by brands
        let brandManager = BrandManager.shared
        let brandNames = brandManager.selectedBrandNames
        
        // Categories should be limited for occasions
        let subcategoryIDs: [Int] = {
            if case let .occasions(id) = section {
                return Occasions.byID[id]?.flatSubcategoryIDs.compactMap { $0 } ?? []
            } else {
                return []
            }
        }()
        
        // If feed type is sale get items with old prices set
        let sale = section == .sale
        
        // Configure parameters for get
        let parametrs = NetworkManager.shared.parameters(
            in: [],
            feeds: feed,
            filteredBy: brandNames,
            for: Gender.current,
            limited: limit,
            named: name,
            sale: sale,
            subcategoryIDs: subcategoryIDs
        )
        
        DispatchQueue.global(qos: .default).async {
            
            // Current count items
            let currentItemsCount = self.items.count
            
            // Request to get items from the API
            NetworkManager.shared.getItems(with: parametrs, offset: self.items.count) { items in
                
                // Check for items availability
                guard let items = items else {
                    debug("ERROR: items is not available")
                    return
                }
                
                // Check count items for zero
                guard items.count != 0 else {
                    debug("INFO: Items count equal zero")
                    
                    // Check Content-Range
                    guard contentRange <= self.items.count else {
                        debug("INFO: We have got already all items")
                        
                        // Switch to false
                        self.itemsDownloaded = false
                        return
                    }
                    
                    // Check count tries and try to get items again
                    if localCountTry < countTry {
                        
                        debug("INFO: How about to try to get items again, Try: ", localCountTry)
                        
                        // Cell function again
                        self.getNewItems(offset: self.items.count, limit: limit)
                        localCountTry += 1
                    }
                    return
                }
                
                // Is filtering and add new items
                self.items += items.filter { !self.items.contains($0) }
                
                
                // Complete when all dispatch group tasks are finished
                DispatchManager.shared.itemManagerGroup.notify(queue: .global(qos: .default)) {
                    
                    debug(currentItemsCount, self.items.count)
                    
                    // Check limit
                    if currentItemsCount == self.items.count || limitSection == self.items.count {
                        
                        // Switch to false and stop download new element
                        self.itemsDownloaded = true
                        
                    } else {
                        
                        // Return to main thead
                        DispatchQueue.main.async {
                            
                            // Reload data
                            if AppDelegate.canReload && self.itemCollectionView?.hasUncommittedUpdates == false {
                                self.itemCollectionView?.reloadData()
                            }
                            
                            // Switch to false
                            self.itemsDownloaded = false
                            
                            // Set local counter to zero
                            localCountTry = 0
                        }
                    }
                }
            }
        }
    }
}
