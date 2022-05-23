//
//  FeedCollectionViewController+Sections.swift
//  Outfit Selection
//
//  Created by Evgeniy Goncharov on 19.05.2022.
//  Copyright © 2022 Denis Bystruev. All rights reserved.
//

import Foundation

extension FeedCollectionViewController {
    
    /// Gets items depending on feed type (section)
    /// - Parameters:
    ///   - type: PickType
    ///   - ignoreBrands: should we ignore brands (false by default)
    ///   - completion: closure without parameters
    func getItems(for type: PickType, ignoreBrands: Bool = false, completion: @escaping () -> Void) {
        
        // Helper properties
        var limited: Int = self.maxItemsInSection * 2
        var subcategoryIDs: [Int] = []
        var vendorNames = brandManager.selectedBrandNames
        var excluded: [Int] = []
        var sale: Bool = false
        
        // Switch for PickType
        switch type {
            
        case .brand(let brand):
            vendorNames = getParamsFor(brandName: brand)
            
        case .occasion(let occasionName):
            let answer = getParamsForCategories(occasionName: occasionName)
            subcategoryIDs = answer.1
            vendorNames = answer.0
            
        case .category(let category):
            let answer = getParamsFor(categoryName: category, limit: 30)
            excluded = answer.1
            vendorNames = answer.0
            
        case .daily(let limit):
            limited = limit
            
        case .occasions(let id):
            subcategoryIDs = getParamsFor(id: id)
            
        case .newItems:
            debug("Section", type)
            
        case .sale:
            sale = true
            
        default:
            debug("ERROR: Unknown section type", type)
            self.items[type] = []
            completion()
            return
        }
        
        // debug(limited, subcategoryIDs, vendorNames, excluded)
        
        NetworkManager.shared.getItems(
            excluded: excluded.isEmpty ? [] : excluded,
            filteredBy: ignoreBrands ? [] : vendorNames,
            limited: limited,
            sale: sale,
            subcategoryIDs: excluded.isEmpty ? subcategoryIDs : []
        ) { [weak self] items in
            // Check for self availability
            guard let self = self else {
                debug("ERROR: self is not available")
                completion()
                return
            }
            
            // Check items is empty and shuffled it
            guard var items = items?.shuffled(), !items.isEmpty else {
                // If no items were returned try again ignoring brands
                if !ignoreBrands {
                    self.getItems(for: type, ignoreBrands: true) {
                        completion()
                    }
                } else {
                    self.items[type] = []
                    completion()
                }
                return
            }
            
            // Put the last selected brand name first
            if let lastSelectedBrandName = self.brandManager.lastSelected?.brandName {
                let lastSelectedBrandNames = [lastSelectedBrandName]
                items.sort { $0.branded(lastSelectedBrandNames) || !$1.branded(lastSelectedBrandNames)}
            }
            
            // Set items into current section
            self.items[type] = items
            
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    
    // MARK: - Private Methods
    /// Return vendor name
    /// - Parameter brandName: brand name
    /// - Returns: array with brand name
    private func getParamsFor(brandName: String) -> [String] {
        return [brandName] // vendorNames
    }
    
    /// Return vendorNames, subCategoryIDs and limit
    /// - Parameters:
    ///   - categoryName: category name
    ///   - limit: the limit for result
    /// - Returns: (~vendorNames, subCategoryIDs, limit)
    private func getParamsFor(categoryName: String, limit: Int) -> ([String], [Int], Int)  {
        let answer = getParamsForCategories(occasionName: categoryName)
        return (answer.0, answer.1, limit)  // (~vendorNames, subCategoryIDs, limit)
    }
    
    /// Return vendor names
    /// - Returns: Return array with vendor names
    private func getParamsForBrandNames() -> [String] {
        // All sections brand names
        let vendorNames = brandManager.selectedBrandNames
        return vendorNames  // vendorNames
    }
    
    /// Return vendorNames and subCategoryIDs
    /// - Parameter occasionName: occasion name for seacher into Occasio. byTitle
    /// - Returns: (vendorNames, subCategoryIDs)
    private func getParamsForCategories(occasionName: String) -> ([String], [Int]) {
        // All sections brand names
        let vendorNames = brandManager.selectedBrandNames
        
        // Categories for occasions
        let subCategoryIDs = Occasions.byTitle[occasionName]?.flatSubcategoryIDs.compactMap { $0 } ?? []
        return (vendorNames, subCategoryIDs) // (vendorNames, subCategoryIDs)
    }
    
    /// Categories should be limited for occasions
    /// - Parameter id: id for seacher into Occasions
    /// - Returns: IDs
    private func getParamsFor(id: Int) -> [Int] {
        return Occasions.byID[id]?.flatSubcategoryIDs.compactMap { $0 } ?? [] // [subCategoryIDs]
    }
    
    ///  30 random items (?)
    /// - Parameter daily: limit
    /// - Returns: count items
    private func getParamsFor(daily: Int) -> Int {
        return daily // (subCategoryIDs, limit)
        //   ⁃ all items your *gender*
        //    ⁃ all items your *favorite brands*
        //    ⁃ all items from occasion your *chosen occasions*
        //    ⁃ 30 random items (?)
    }
    
}
