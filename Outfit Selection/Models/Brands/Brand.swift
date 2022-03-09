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
    var image: UIImage?
    
    /// The URL to load image from
    let imageURL: URL?
    
    /// Status selected brand by the user
    private(set) var isSelected: Bool
    
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
    
    // MARK: - Mathods
    /// Select / deselect this brand and update / skip updating user defaults
    /// - Parameters:
    ///   - isSelected: true if this brand should be selected, false otherwise
    ///   - updateUserDefaults: true if user defaults should be updated (default)
    func select(isSelected: Bool, updateUserDefaults: Bool = true) {
        guard isSelected != self.isSelected else { return }
        self.isSelected = isSelected
        if updateUserDefaults { Brands.saveSelectedBrands() }
        if isSelected { Brands.lastSelected = isSelected }
    }
    
    /// Toggle selection of this brand
    func toggleSelection() {
        select(isSelected: !isSelected)
    }
}
