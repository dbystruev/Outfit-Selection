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
    /// Private branded images
    private var _brandedImages: BrandedImages?
    
    /// Last selected branded image
    weak var lastSelected: BrandedImage?
    
    // MARK: - Computed Properties
    /// Available brand images
    var brandedImages: BrandedImages {
        get {
            guard let brandedImages = _brandedImages else {
                let selectedBrands = Brands.loadSelectedBrands().map { $0.lowercased() }
                _brandedImages = BrandedImages(fullNames.compactMap {
                    let brandedImage = BrandedImage(contentsOfFile: $0)
                    let brandName = $0.lastComponent.dropExtension
                    brandedImage?.brandName = brandName
                    brandedImage?.isSelected = selectedBrands.contains(brandName.lowercased())
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
    
    /// Is loading file and make an array
    var brandNamesFromFile: [String] {
        
        // Get a file from resource
        guard let path = Bundle.main.path(forResource: "brands", ofType: "csv") else {
            debug("ERROR: resource file not found" )
            return [] }
        
        // Load content from the file
        guard let content = try? String(contentsOfFile: path, encoding: .utf8) else {
            debug("ERROR: content can't loaded" )
            return []
        }
        return content.components(separatedBy: "\n").sorted()
    }
    
    /// Sorted full file names of images with brand logos
    private var fullNames: [String] {
        let bundleURL = Bundle.main.bundleURL.appendingPathComponent("Brands.bundle")
        guard let names = try? FileManager.default.contentsOfDirectory(at: bundleURL, includingPropertiesForKeys: nil) else {
            return []
        }
        return names.map({ $0.path }).sorted()
    }
    
    /// Short names of selected brand logos (e. g. ["burberry", "chanel", "fendi", "giorgio armani", "gucci", "hermès", "louis vuitton", "prada", "ralph lauren", "versace"])
    var selectedBrandNames: [String] {
        //selectedBrands.sorted()
        Brands.selected.map{ $0.value.name }
    }
    
    /// Brands currently selected by the user
    var selectedBrands: Set<String> {
        //Set(brandedImages.compactMap { $0.isSelected ? $0.brandName : nil })
        Set(Brands.selected.compactMap { $0.value.isSelected ? $0.value.name : nil })
    }
    
    /// Brands currently not selected by the user
    var unselectedBrands: Set<String> {
        //Set(brandedImages.compactMap { $0.isSelected ? nil : $0.brandName })
        Set(Brands.unselected.compactMap { $0.value.isSelected ? nil : $0.value.name })
    }
}
