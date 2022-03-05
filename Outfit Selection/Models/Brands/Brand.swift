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
    /// Sets whether this brand image is selected without updating user defaults
    private var _isSelected: Bool?
    
    // MARK: - Stored Properties
    /// Identificator for brand
    var id: Int?
    
    /// The name of the brand
    let name: String
    
    /// Brand logo image
    var image: UIImage?
    
    /// The URL to load image from
    let imageURL: URL?
    
    /// Status selected brand by the user
    var isSelected: Bool {
        get { _isSelected ?? false }
        set {
            guard newValue != _isSelected else { return }
            _isSelected = newValue
            BrandManager.shared.saveSelectedBrands()
            if newValue {
                Brands.lastSelected = isSelected
            }
        }
    }
    
    /// True if this branded image was last selected by the user
    var isLastSelected: Bool? { Brands.lastSelected }
    
    // MARK: - Init
    /// Constructor for brands
    /// - Parameters:
    ///   - id: brand ID
    ///   - name: the name of the brands
    ///   - image: the image
    ///   - imageURL: the image URL
    ///   - isSelected: whether the brand is selected by the user, false by default
    ///   - isLastSelected: it will be changet after isSelected
    init(
        id: Int? = nil,
        name: String,
        image: UIImage? = nil,
        imageURL: URL? = nil,
        isSelected: Bool,
        isLastSelected: Bool? = nil
    ) {
        self.id = id
        self.name = name
        self.image = image
        self.imageURL = imageURL
        self.isSelected = isSelected
    }
}
