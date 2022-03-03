//
//  Brand.swift
//  Outfit Selection
//
//  Created by Evgeniy Goncharov on 03.03.2022.
//  Copyright © 2022 Denis Bystruev. All rights reserved.
//

import UIKit

/// Brands to create
final class Brand {
    // MARK: - Stored Properties
    /// Identificator for brand
    var id: Int?
    
    /// The name of the brand
    let name: String
    
    /// Brand logo image
    let image: UIImage?
    
    /// The URL to load image from
    let imageURL: URL?
    
    /// Status selected brand by the user
    let isSelected: Bool
    
    // MARK: - Init
    /// Constructor for brands
    /// - Parameters:
    ///   - id: brand ID
    ///   - name: the name of the brands
    ///   - image: the image
    ///   - imageURL: the image URL
    ///   - isSelected: whether the brand is selected by the user, false by default
    init(
        id: Int?,
        name: String,
        image: UIImage?,
        imageURL: URL?,
        isSelected: Bool
    ) {
        self.id = id
        self.name = name
        self.image = image
        self.imageURL = imageURL
        self.isSelected = isSelected
    }
}
