//
//  FeedCollectionViewController+Picks.swift
//  Outfit Selection
//
//  Created by Evgeniy Goncharov on 23.05.2022.
//  Copyright © 2022 Denis Bystruev. All rights reserved.
//

import Foundation

extension FeedCollectionViewController {
    // MARK: - Methods
    /// Gets items depending on feed type (section)
    /// - Parameters:
    ///   - pick: pick for get items
    ///   - completion: closure without parameters
    func getItems(for pick: Pick, completion: @escaping (Items?) -> Void) {
        
        // Helper properties
        let excluded: [Int] = []
        var gender = Gender.current
        var limited = maxItemsInSection * 2
        var random = false
        var sale = false
        var subcategoryIDs: [Int] = []
        var vendorNames: [String] = []
        
        for filter in pick.filters {
            
            // Switch for filters
            switch filter {
                
            case .additionalBrands:
                // TODO: Change to additionalBrands
                vendorNames = brandManager.selectedBrandNames
                
            case .brand:
                guard let name = pick.type.name else { return }
                vendorNames = [name]
                
            case .brands:
                vendorNames = brandManager.selectedBrandNames
                
            case .category:
                // Get category name from pick type
                guard let name = pick.type.name else { return }
                
                // Find id from categories
                let byID = Categories.byID.filter { $0.value.name == name }
                let id = byID.map { $0.key }
                
                // Set limit
                limited = pick.limit ?? self.maxItemsInSection * 2
                
                // Set subcategoryIDs
                subcategoryIDs = id
                
            case .daily:
                vendorNames = brandManager.selectedBrandNames
                
            case .excludeBrands:
                vendorNames = brandManager.unselectedBrandNames
                
            case .gender:
                gender = Gender.current
                
            case .occasion:
                // Get occasion name from pick type
                guard let name = pick.type.name else { return }
                
                // Find id from Occasions
                let occasion = Occasions.with(name: name)
                let id = occasion.map { $0.id }
                
                // Set subcategoryIDs
                subcategoryIDs = id
                
            case .occasions:
                subcategoryIDs = Occasions.selectedIDs
                
            case .random:
                random = true
                
            case .sale:
                sale = true
            }
        }
        
        NetworkManager.shared.getItems(
            excluded: excluded.isEmpty ? [] : excluded,
            filteredBy: vendorNames,
            for: gender,
            limited: limited,
            sale: sale,
            subcategoryIDs: excluded.isEmpty ? subcategoryIDs : []
        ) { items in
            // Return items and shuffle them if needed
            completion(random ? items?.shuffled() : items)
        }
    }
    
    /// Get items and set it into picks for DataSource
    /// - Parameter picks: picks for get items
    /// - Parameter inBatch: if true — update all items in one batch, false by default
    func updateItems(picks: Picks, inBatch: Bool = false) {
        
        // Make expand picks
        let expandedPicks = expand(picks: picks)
        
        // The sections to insert later
        var insertSections: IndexSet = []
        
        // Dispatch group to wait for all requests to finish
        let group = DispatchGroup()
        
        // For pick in picks
        for (index, pick) in expandedPicks.enumerated() {
            
            group.enter()
            if pick.limit == 0 {
                debug("Skipped:", pick.type, "|",  pick.title)
                displayedPicks.append(pick)
                group.leave()
                continue
            }
            
            // Get items for pick
            getItems(for: pick) { [weak self] items in
                guard let self = self else {
                    debug("Self is nil")
                    group.leave()
                    return
                }
                
                guard let items = items, !items.isEmpty else {
                    debug("No items:", pick.type, "|",  pick.title)
                    group.leave()
                    return
                }
                
                debug("Items count:", items.count, pick.type, "|",  pick.title)
                
                DispatchQueue.main.async {
                    let collectionIndex: Int
                    if index < self.displayedPicks.count {
                        collectionIndex = index
                        self.displayedPicks.insert(pick, at: index)
                    } else {
                        collectionIndex = self.displayedPicks.count
                        self.displayedPicks.append(pick)
                    }
                    
                    // Add items into pickItems
                    self.pickItems[pick] = items
                    
                    // TODO: Lock See all button when items is downloading
                    if inBatch {
                        insertSections.insert(collectionIndex)
                    } else {
                        self.feedCollectionView.insertSections([collectionIndex])
                    }
                    
                    group.leave()
                }
            }
        }
        
        // Notification from DispatchQueue group when all section got answer
        group.notify(queue: .main) { [weak self] in
            // Reload data into UICollectionView
            if AppDelegate.canReload && self?.feedCollectionView?.hasUncommittedUpdates == false {
                if !insertSections.isEmpty {
                    self?.feedCollectionView.insertSections(insertSections)
                }
                
                // TODO: Unlock See all buttons
                self?.feedCollectionView?.reloadData()
            }
            debug("INFO: finished getting items", "Picks:", self?.displayedPicks.count )
        }
    }
    
    // MARK: - Private Methods
    /// Expand empty pick types (.occasion(" "), .brand(" "), .category(" "))
    /// - Parameter picks: Picks with empty PickType
    /// - Returns: Picks array with all empty PickType expanded
    private func expand(picks: Picks) -> Picks {
        var expandedPicks: Picks = []
        
        for pick in picks {
            switch pick.type {
            case .hello:
                let userName = User.current.displayName?.components(separatedBy: " ").first ?? ""
                let pickTitle = currentUser.isLoggedIn == true ? pick.title + userName : pick.title
                let pick = Pick(.hello, limit: pick.limit, subtitles: pick.subtitles, title: pickTitle)
                expandedPicks.append(pick)
                
            case .occasion(""):
                let picks = pickOccasion(pick: pick)
                expandedPicks += picks
                
            case .brand(""):
                let picks = pickBrand(pick: pick)
                expandedPicks += picks
                
            case .category(""):
                let picks = pickCategory(pick: pick)
                expandedPicks += picks
                
            default:
                expandedPicks.append(pick)
            }
        }
        return expandedPicks
    }
    
    /// Private method for make expanded (.brand)
    /// - Parameter pick: pick with empty (.brand) PickType for expand
    /// - Returns: array with picks
    private func pickBrand(pick: Pick) -> Picks {
        let selectedBrands = Brands.selected
        let picks = selectedBrands.map { Pick(
            .brand($0.value.name),
            filters: pick.filters, title: pick.title + $0.value.name)
        }
        return picks
    }
    
    /// Private method for make expanded (.category)
    /// - Parameter pick: pick with empty (.category) PickType for expand
    /// - Returns: array with picks
    func pickCategory(pick: Pick) -> Picks {
        let selectedOccasions = Occasions.selected
        let categories = Categories.all.filtered(by: selectedOccasions)
        let picks = categories.map { Pick(
            .category($0.name),
            filters: pick.filters, limit: pick.limit, title: $0.name + pick.title)
        }
        return picks
    }
    
    /// Private method for make expanded (.occasion)
    /// - Parameter pick: pick with empty (.occasion) PickType for expand
    /// - Returns: array with picks
    private func pickOccasion(pick: Pick) -> Picks {
        let selectedOccasions = Occasions.selectedUniqueTitle
        let picks = selectedOccasions.map { Pick(
            .occasion($0.title),
            filters: pick.filters, subtitles: pick.subtitles, title: pick.title + $0.title)
        }
        return picks
    }
}
