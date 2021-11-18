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
    private var images: [ItemImage] = []
        
    // MARK: - Computed properties
    /// The number of images stored in view model
    public var count: Int { images.count }
    
    /// Items associated with images stored in the view model
    public var items: Items { images.compactMap { $0.item } }
    
    /// Subscript to get access to images and tags
    subscript(_ index: Int) -> ItemImage { images[index] }
    
    // MARK: - Methods
    /// Append a non-nil image to image collection view model
    /// - Parameter image: the image to append, not appending if nil
    func append(_ image: UIImage?, item: Item) {
        // Don't use nil images
        guard let cgImage = image?.cgImage else { return }
        
        // Create branded image
        let itemImage = ItemImage(cgImage: cgImage)
        itemImage.item = item
        
        // Append the image to the array of images
        images.append(itemImage)
    }
    
    /// Filter images by given brands
    /// - Parameter brandNames: brand names to filter images by
    /// - Returns: filtered branded image array
    func branded(_ brandNames: [String]) -> [ItemImage] {
        images.filter { $0.item?.branded(brandNames) == true }
    }
    
    /// Clear all images stored in image collection view model
    func removeAll() {
        images.removeAll()
    }
}
