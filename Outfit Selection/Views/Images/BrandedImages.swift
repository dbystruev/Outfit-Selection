//
//  BrandedImages.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 28.03.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

/// Class which consist of branded images
class BrandedImages {
    /// Define the `+` operator for branded images
    /// - Parameters:
    ///   - lhs: left side of the operator
    ///   - rhs: right side of the operator
    /// - Returns: result of `+` operation
    static func + (lhs: BrandedImages, rhs: BrandedImages) -> BrandedImages {
        BrandedImages(lhs.images + rhs.images)
    }
    
    // MARK: - Properties
    /// Internal collection which holds branded images
    var images: [BrandedImage]
    
    // MARK: - Computed Properties
    /// The  names of the branded images
    var brandNames: [String] {
        images.compactMap { $0.brandName }
    }
    
    /// The number of images in the internal collection
    var count: Int { images.count }
    
    /// Filter brand names by this string
    var filter = ""
    
    /// Branded images filtere by brand
    var filtered: BrandedImages { filter { filter.isEmpty ? true : $0.branded([filter]) } }
    
    /// All branded images with last selected first
    var prioritizeLastSelected: BrandedImages {
        guard let lastSelected = BrandManager.shared.lastSelected else { return self }
        return BrandedImages([lastSelected]) + filter { !$0.isLastSelected }
    }
    
    /// All branded images sorted by selected first
    var prioritizeSelected: BrandedImages { selected + unselected }
    
    /// Branded images currently selected by the user
    var selected: BrandedImages { filter { $0.isSelected }}
    
    /// Image of the internal array with a given index
    subscript(index: Int) -> BrandedImage { images[index] }
    
    /// Branded images currently unselected by the user
    var unselected: BrandedImages { filter { !$0.isSelected }}
    
    // MARK: - Init
    /// Initializes the internal collection of images
    /// - Parameter images: imags to initialize the internal collection width, empty by default
    init(_ images: [BrandedImage] = []) {
        self.images = images
    }
    
    // MARK: - Methods
    /// Adds an image to the end of the internal collection
    /// - Parameter newImage: the image to append to the collection
    func append(_ newImage: BrandedImage) {
        images.append(newImage)
    }
    
    /// Returns an array containing the non-nil results of calling the given transformation with each image of the internal collection
    /// - Parameter transform: a closure that accepts an image of the internal collection and returns an optional value
    /// - Returns: an array of the non-nil results of calling transform with each image of the internal collection
    func compactMap<ElementOfResult>(_ transform: (BrandedImage) throws -> ElementOfResult?) rethrows -> [ElementOfResult] {
        try images.compactMap(transform)
    }
    
    /// Returns internal collection containing, in order, the images that satisfy the given predicate
    /// - Parameter isIncluded: a closure that takes an image and returns a true if the image should be included in the returned collection
    /// - Returns: a collection of the images that isIncluded allowed
    func filter(_ isIncluded: (BrandedImage) throws -> Bool) rethrows -> BrandedImages {
        let newImages = try images.filter(isIncluded)
        return BrandedImages(newImages)
    }
    
    /// Calls the given closure on each image of the collection in the same order as for-in loop
    /// - Parameter body: a closure that takes an image from the sequence as the parameter
    func forEach(_ body: (BrandedImage) throws -> Void) rethrows {
        try images.forEach(body)
    }
    
    /// Removes all images from the collection
    func removeAll() {
        images.removeAll()
    }
}
