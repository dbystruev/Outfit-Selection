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
    /// The make expand emptty pick types (.occasion(" "), .brand(" "), .category(" "))
    /// - Parameter picks: Picks with empty PickType
    /// - Returns: array Picks aftert expand all empty PickType
    func expand(picks: Picks) -> Picks {
        var expandedPiks: Picks = []
        
        for pick in picks {
            switch pick.type {
            case .hello:
                var pick = Pick(.hello, limit: pick.limit, subtitles: pick.subtitles, title: pick.title)
                if currentUser.isLoggedIn == true {
                    let userName = User.current.displayName ?? ""
                    pick = Pick(.hello, limit: pick.limit, subtitles: pick.subtitles, title: pick.title + userName )
                }
                expandedPiks.append(pick)
                
            case .occasion(""):
                let picks = pickOccasion(pick: pick)
                expandedPiks += picks
                
            case .brand(""):
                let picks = pickBrand(pick: pick)
                expandedPiks += picks
                
            case .category(""):
                let picks = pickCategory(pick: pick)
                expandedPiks += picks
                
            default:
                expandedPiks.append(pick)
            }
        }
        
        return expandedPiks
    }
    
    /// Gets items depending on feed type (section)
    /// - Parameters:
    ///   - pick: pick for get items
    ///   - completion: closure without parameters
    func getItems(for pick: Pick, completion: @escaping (Items?) -> Void) {
        
        // Helper properties
        let excluded: [Int] = []
        var gender = Gender.current
        var limited: Int = self.maxItemsInSection * 2
        var random: Bool = false
        var sale: Bool = false
        var subcategoryIDs: [Int] = []
        var vendorNames: [String] = []
        
        
        for filter in pick.filters {
            
            // Switch for filters
            switch filter {
                
            case .additionalBrands:
                // TODO: Change to additionalBrands
                debug("Add additionalBrands in to Network manager")
                vendorNames = brandManager.selectedBrandNames
                
            case .brand:
                guard let name = pick.type.name else { return }
                vendorNames = [name]
                
            case .brands:
                vendorNames = brandManager.selectedBrandNames
                
            case .category:
                guard let name = pick.type.name else { return }
                limited = pick.limit ?? self.maxItemsInSection * 2
                let answer = getParamsFor(categoryName: name, limit: limited )
                subcategoryIDs = answer.1
                
            case .excludeBrands:
                debug("Add excludeBrands in to Network manager")
                // TODO: Add unselected barnds
                
            case .gender:
                gender = Gender.current
                
            case .occasion:
                guard let name = pick.type.name else { return }
                let answer = getParamsForCategories(occasionName: name)
                subcategoryIDs = answer.1
                
            case .occasions:
                subcategoryIDs = Occasions.selectedIDs
                
            case .random:
                random = true
                
            case .sale:
                sale = true
                
            default:
                debug("ERROR: Unknown filter", filter.rawValue)
            }
        }
        
        NetworkManager.shared.getItems(
            excluded: excluded.isEmpty ? [] : excluded,
            filteredBy: vendorNames,
            for: gender,
            limited: limited,
            sale: sale,
            subcategoryIDs: excluded.isEmpty ? subcategoryIDs : []
        ) { [weak self] items in
            // Check for self availability
            guard self != nil else {
                debug("ERROR: self is not available")
                return
            }
            
            // Check items is empty
            guard let items = items, !items.isEmpty else {
                debug("ERROR: Items is empty")
                return
            }
            
            // Return Items and shuffling if it need
            completion(random ? items.shuffled() : items)
        }
    }
    
    // MARK: - Private Methods
    /// Private method for make expanded (.brand)
    /// - Parameter pick: pick with empty (.brand) PickType for expand
    /// - Returns: array with picks
    private func pickBrand(pick: Pick) -> Picks {
        let selectedBrands = Brands.selected
        let picks = selectedBrands.map { Pick(.brand($0.value.name), filters: pick.filters, title: pick.title + $0.value.name) }
        return picks
    }
    
    /// Private method for make expanded (.category)
    /// - Parameter pick: pick with empty (.category) PickType for expand
    /// - Returns: array with picks
    func pickCategory(pick: Pick) -> Picks {
        let selectedOccasion = Occasions.selected
        let categories = Categories.all.filtered(by: selectedOccasion)
        let picks = categories.map { Pick(.category($0.name), filters: pick.filters, limit: pick.limit, title: $0.name + pick.title) }
        return picks
    }

    /// Private method for make expanded (.occasion)
    /// - Parameter pick: pick with empty (.occasion) PickType for expand
    /// - Returns: array with picks
    private func pickOccasion(pick: Pick) -> Picks {
        let selectedOccasion = Occasions.selectedUniqueTitle
        let picks = selectedOccasion.map { Pick(.occasion($0.title), filters: pick.filters, subtitles: pick.subtitles, title: pick.title + $0.title) }
        return picks
    }
    
}
