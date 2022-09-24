//
//  ImageCollectionViewModels.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 18.11.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import UIKit

typealias ImageCollectionViewModels = [ImageCollectionViewModel]

extension ImageCollectionViewModels: ItemSearchable {
    /// Items stored in all view models
    var corneredItems: [Items] {
        map { $0.items }
    }
    
    /// Get an image for the given item ID
    /// - Parameter itemID: item ID to search for
    /// - Returns: image corresponsing to the given item ID, or nil if not found
    func image(for itemID: String) -> UIImage? {
        images.first { $0.item?.id == itemID }
    }
    
    /// All images in all view models
    var images: [ItemImage] {
        flatMap { $0.images }
    }
    
    /// All items in all view models
    var items: Items {
        flatMap { $0.items }
    }
}
