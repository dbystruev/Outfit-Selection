//
//  FeedCollectionViewController+Sections.swift
//  Outfit Selection
//
//  Created by Evgeniy Goncharov on 19.05.2022.
//  Copyright © 2022 Denis Bystruev. All rights reserved.
//

import Foundation

extension FeedCollectionViewController {
    
    /// Return vendor name
    /// - Parameter brandName: brand name
    /// - Returns: array with brand name
    func getParamsFor(brandName: String) -> [String] {
        return [brandName] // vendorNames
    }
    
    /// Return vendorNames, subCategoryIDs and limit
    /// - Parameters:
    ///   - categoryName: category name
    ///   - limit: the limit for result
    /// - Returns: (~vendorNames, subCategoryIDs, limit)
    func getParamsFor(categoryName: String, limit: Int) -> ([String], [Int], Int)  {
        let answer = getParamsForCategories(occasionName: categoryName)
        return (answer.0, answer.1, limit)  // (~vendorNames, subCategoryIDs, limit)
    }
    
    /// Return vendor names
    /// - Returns: Return array with vendor names
    func getParamsForBrandNames() -> [String] {
        // All sections brand names
        let vendorNames = brandManager.selectedBrandNames
        return vendorNames  // vendorNames
    }
    
    /// Return vendorNames and subCategoryIDs
    /// - Parameter occasionName: occasion name for seacher into Occasio. byTitle
    /// - Returns: (vendorNames, subCategoryIDs)
    func getParamsForCategories(occasionName: String) -> ([String], [Int]) {
        // All sections brand names
        let vendorNames = brandManager.selectedBrandNames
        
        // Categories for occasions
        let subCategoryIDs = Occasions.byTitle[occasionName]?.flatSubcategoryIDs.compactMap { $0 } ?? []
        return (vendorNames, subCategoryIDs) // (vendorNames, subCategoryIDs)
    }
    
}
