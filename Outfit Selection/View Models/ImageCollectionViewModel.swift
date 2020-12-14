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
    private var images = [UIImage]()
    
    /// Tags stored in view model
    private var tags = [Int]()
    
    // MARK: - Computed properties
    /// The number of images stored in view model
    public var count: Int { images.count }
    
    /// Subscript to get access to images and tags
    subscript(_ index: Int) -> (UIImage, Int) {
        (images[index], tags[index])
    }
    
    // MARK: - Methods
    /// Append a non-nil image to image collection view model
    /// - Parameter image: the image to append, not appending if nil
    func append(_ image: UIImage?, tag: Int) {
        guard let image = image else { return }
        images.append(image)
        tags.append(tag)
    }
    
    /// Clear all images stored in image collection view model
    func removeAll() {
        images.removeAll()
        tags.removeAll()
    }
}
