//
//  Brands+all.swift
//  Outfit Selection
//
//  Created by Evgeniy Goncharov on 03.03.2022.
//  Copyright © 2022 Denis Bystruev. All rights reserved.
//

import Foundation

extension Brands {
    // MARK: - Static Stored Properties
    /// All brands
    static var all: [Brand] {
        Array(byName.values)
    }
    
    /// All brands by name
    private(set) static var byName: Brands = [:]
    
    /// The count of barnds
    static var count: Int { byName.count }
    
    /// True if brands are empty, false otherwise
    static var isEmpty: Bool { byName.isEmpty }
    
    // MARK: - Static Methods
    /// Append  brand to  all brands
    /// - Parameter brand: brand to add
    static func append(_ brand: Brand) {
        let name = brand.name.lowercased()
        brand.image = brand.image ?? byName[name]?.image
        byName[name] = brand
    }
    
    /// Append array brands to all brands
    /// - Parameter brandNames: array of brand names
    static func append(_ brandNames: [String]) {
        let selectedBrands = Brands.loadSelectedBrands().map { $0.lowercased() }
        for brandName in brandNames {
            let newBrand = Brand(name: brandName, isSelected: selectedBrands.contains(brandName.lowercased()))
            append(newBrand)
        }
    }
    
    /// Append array brands to  all brands
    /// - Parameter brands: array brands
    static func append(_ brandedImages: BrandedImages) {
        for brandedImage in brandedImages.images {
            
            let newBrand = Brand(
                name: brandedImage.brandName ?? "",
                image: brandedImage,
                isSelected: brandedImage.isSelected
            )
            
            append(newBrand)
        }
    }
    
    /// Select / deselect given brand
    /// - Parameters:
    ///   - brandName: the name of the brand to select / deselect
    ///   - isSelected: true — select, false — deselect
    ///   - updateUserDefaults: if true — update user defaults (default), if not — don't
    static func select(_ brandName: String, isSelected: Bool, updateUserDefaults: Bool = true) {
        byName[brandName.lowercased()]?.select(isSelected: isSelected, updateUserDefaults: updateUserDefaults)
    }
    
    /// Update selection status of all brands and update user defaults
    /// - Parameter selectedBrands: the list of selected brands
    static func update(selectedBrands: [String]) {
        // Clear selection of all brands
        all.forEach { $0.select(isSelected: false, updateUserDefaults: false) }
        
        // Select the brands present in the given list
        selectedBrands.forEach {
            byName[$0.lowercased()]?.select(isSelected: true, updateUserDefaults: false)
        }
        
        // Save all seleced brands
        saveSelectedBrands()
    }
}
