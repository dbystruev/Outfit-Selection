//
//  BrandManager.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 23.11.2020.
//  Copyright © 2020 Denis Bystruev. All rights reserved.
//

import UIKit

class BrandManager {
    // MARK: - Static Properties
    static let shared = BrandManager()
    
    // MARK: - Init
    private init() {}
    
    // MARK: - Stored Properties
    private var _brandedImages: BrandedImages?
    
    // MARK: - Computed Properties
    /// Available brand images
    var brandedImages: BrandedImages {
        get {
            guard let brandedImages = _brandedImages else {
                _brandedImages = BrandedImages(fullNames.compactMap {
                    let brandedImage = BrandedImage(contentsOfFile: $0)
                    brandedImage?.brandName = $0.lastComponent.dropExtension
                    return brandedImage
                })
                return _brandedImages ?? BrandedImages()
            }
            return brandedImages
        }
        set {
            _brandedImages = newValue
        }
    }
    
    /// Short names of available brand logos (e. g. ["burberry", "chanel", "fendi", "giorgio armani", "gucci", "hermès", "louis vuitton", "prada", "ralph lauren", "versace"])
    var brandNames: [String] {
        fullNames.map { $0.lastComponent.dropExtension }
    }
    
    /// Sorted full file names of images with brand logos
    var fullNames: [String] {
        let bundleURL = Bundle.main.bundleURL.appendingPathComponent("Brands.bundle")
        guard let names = try? FileManager.default.contentsOfDirectory(at: bundleURL, includingPropertiesForKeys: nil) else {
            return []
        }
        return names.map({ $0.path }).sorted()
    }
    
    /// Brands currently selected by the user
    var selectedBrands: Set<String> {
        Set(brandedImages.compactMap { $0.isSelected ? $0.brandName : nil })
    }
    
    /// Brands currently not  selected by the user
    var unselectedBrands: Set<String> {
        Set(brandedImages.compactMap { $0.isSelected ? nil : $0.brandName })
    }
}
