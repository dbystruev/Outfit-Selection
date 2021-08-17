//
//  ImageCollectionViewModel.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 14.12.2020.
//  Copyright © 2020 Denis Bystruev. All rights reserved.
//

import UIKit

/// Class  to store images before inserting them into scroll views
class ImageCollectionViewModel {
    // MARK: - Static Computed Properties
    /// Empty image collection view model
    public static var empty: ImageCollectionViewModel { ImageCollectionViewModel() }
    
    // MARK: - Stored Properties
    /// Images stored in view model
    private var images = BrandedImages()
        
    // MARK: - Computed properties
    /// The number of images stored in view model
    public var count: Int { images.count }
    
    /// Subscript to get access to images and tags
    subscript(_ index: Int) -> BrandedImage { images[index] }
    
    // MARK: - Methods
    /// Append a non-nil image to image collection view model
    /// - Parameter image: the image to append, not appending if nil
    func append(_ image: UIImage?, tag: Int, vendor: String?) {
        // Don't use nil images
        guard let cgImage = image?.cgImage else { return }
        
        // Create branded image
        let brandedImage = BrandedImage(cgImage: cgImage)
        brandedImage.brandName = vendor ?? ""
        brandedImage.tag = tag
        
        // Append the image to the array of images
        images.append(brandedImage)
    }
    
    /// Filter images by given brands
    /// - Parameter brandNames: brand names to filter images by
    /// - Returns: filtered branded image array
    func branded(_ brandNames: [String]) -> BrandedImages {
        images.filter { $0.branded(brandNames) }
    }
    
    /// Clear all images stored in image collection view model
    func removeAll() {
        images.removeAll()
    }
}
