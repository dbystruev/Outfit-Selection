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
    
    // MARK: - Static Methods
    /// Append  brand to  all brands
    /// - Parameter brand: brand to add
    static func append(_ brand: Brand) {
        let name = brand.name.lowercased()
        brand.image = brand.image ?? byName[name]?.image
        byName[name] = brand
    }
    
    /// Append array brands to all brands
    /// - Parameter brands: array brands
    static func append(_ brands: [String]) {
        for brand in brands {
            let newBrand = Brand(name: brand, isSelected: false)
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
}
