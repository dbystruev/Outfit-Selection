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
    
    // MARK: - Computed Properties
    /// Available brand images
    var brandImages: [UIImage] {
        fullNames.compactMap { UIImage(contentsOfFile: $0) }
    }
    
    /// Sorted full file names of images with brand logos
    var fullNames: [String] {
        let bundleURL = Bundle.main.bundleURL.appendingPathComponent("Brands.bundle")
        guard let names = try? FileManager.default.contentsOfDirectory(at: bundleURL, includingPropertiesForKeys: nil) else {
            return []
        }
        return names.map({ $0.path }).sorted()
    }
    
    /// Short names of available brand logos (e. g. ["burberry", "chanel", "fendi", "giorgio armani", "gucci", "hermès", "louis vuitton", "prada", "ralph lauren", "versace"])
    var brandNames: [String] {
        fullNames.map { $0.lastComponent.dropExtension }
    }
}
