//
//  ItemManager.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 23.11.2020.
//  Copyright © 2020 Denis Bystruev. All rights reserved.
//

import UIKit

class ItemManager {
    // MARK: - Static Properties
    static let shared = ItemManager()
    
    // MARK: - Init
    private init() {}
    
    // MARK: - Stored Properties
    /// imagePrefixes should correspond to scrollViews
    let imagePrefixes = ["TopLeft", "BottomLeft", "TopRight", "MiddleRight", "BottomRight"]
    
    /// The number of images loaded into scroll views
    var imagesLoaded = 0
    
    /// Array of category image collection view models
    let viewModels: [ImageCollectionViewModel] = (0 ..< Category.all.count).map { _ in ImageCollectionViewModel.empty }
    
    // MARK: - Methods
    /// Call completion closure if all categories and all items were looped through
    /// - Parameters:
    ///   - success: true if there were no single error while loading items' images
    ///   - itemsRemaining: the number of items in category remaining to loop through
    ///   - completion: closure with int parameter which is called when all images are processed, parameter holds the number of items loaded
    func checkForCompletion(remaining: Int, completion: @escaping (_ success: Int) -> Void) {
        if remaining < 1 {
            completion(imagesLoaded)
        }
    }
    
    /// Clear all view models
    func clearViewModels() {
        viewModels.forEach { $0.removeAll() }
    }
    
    /// Load images filtered by categories into view models
    /// - Parameters:
    ///   - completion: closure with int parameter which is called when all images are processed, parameter holds the number of items loaded
    func loadImages(filteredBy gender: Gender, completion: @escaping (_ count: Int) -> Void) {
        // Items remaining to load into view models
        var itemsRemaining = 0 {
            didSet {
                checkForCompletion(remaining: itemsRemaining, completion: completion)
            }
        }
        
        // Clear all view models
        clearViewModels()
        
        /// Loop all categories and view models, whatever number is lower
        for (categories, viewModel) in zip(Category.filtered(by: gender), ItemManager.shared.viewModels) {
            // The names of the items already loaded in this category
            var loadedItemNames = [String]()
            
            // Get category identifiers
            let categoryIds = categories.map { $0.id }
            
            // Select only the items which belong to one of the categories given
            let filteredItems = Item.all.filter {
                guard let itemCategoryId = $0.categoryId else { return false }
                return categoryIds.contains(itemCategoryId)
            }
            
            // Get Category.maxItemCount items in the given category
            // TODO: shuffle
            let items = filteredItems.prefix(Category.maxItemCount)
            
            // Remember how many items we need to load
            itemsRemaining += items.count
            
            // Loop all items in given category
            for item in items {
                // Don't load items with names similar to already loaded
                guard let itemName = item.name else {
                    // No item name - that's an error
                    debug("ERROR: no item name for item in categories \(categories)")
                    itemsRemaining -= 1
                    continue
                }
                
                // Check that there is no item with the same name already in the list
                guard !loadedItemNames.contains(itemName) else {
                    // Items with similar names - that's not an error, but a warning
                    //debug("WARNING: \(itemName) already loaded in category \(category.name)")
                    itemsRemaining -= 1
                    continue
                }
                
                // Get the item picture url
                guard let pictureURL = item.pictures?.first else {
                    // No picture — that's an error
                    debug("ERROR: No picture URLs for the item", item.name, item.url)
                    itemsRemaining -= 1
                    continue
                }
                
                // Pretend that we have succesfully loaded an item with given name
                loadedItemNames.append(itemName)
                
                // Try to get an image for the current item
                NetworkManager.shared.getImage(pictureURL) { image in
                    // Didn't get the image — that's an error
                    guard let image = image else {
                        debug("ERROR: Can't get an image for the item", item.name, item.url)
                        
                        // Remove item name already added to the array of loaded item names
                        if let itemNameIndex = loadedItemNames.firstIndex(of: itemName) {
                            loadedItemNames.remove(at: itemNameIndex)
                        }
                        
                        itemsRemaining -= 1
                        return
                    }
                    
                    // No item index — that's an error
                    guard let itemIndex = item.itemIndex else  {
                        debug("ERROR: Can't get item index for the item", item.name, item.url)
                        
                        // Remove item name already added to the array of loaded item names
                        if let itemNameIndex = loadedItemNames.firstIndex(of: itemName) {
                            loadedItemNames.remove(at: itemNameIndex)
                        }
                        
                        itemsRemaining -= 1
                        return
                    }
                    
                    self.imagesLoaded += 1
                    
                    // Append image to the end of corresponding image collection view model
                    viewModel.append(image.halved, tag: itemIndex, vendor: item.vendor)
                    itemsRemaining -= 1
                }
            }
        }
    }
    
    /// Load images from view models into scroll views
    /// - Parameters:
    ///   - brands: the names of the brands to filter images by
    ///   - scrollViews: scroll views to load images into, one scroll view for each category
    func loadImages(branded brands: [String], into scrollViews: [PinnableScrollView]) {
        /// Loop all view models and scroll views, whatever number is lower
        for (viewModel, scrollView) in zip(ItemManager.shared.viewModels, scrollViews) {
            // Loop all items in given category filtered by brands
            for brandedImage in viewModel.branded(brands) {
                scrollView.insert(image: brandedImage).tag = brandedImage.tag
            }
        }
    }
    
    /// Load placeholder images in app bundle before items from the server are ready
    /// - Parameter scrollViews: scroll views to insert images into, one scroll view for each category
    /// - Returns: the number of images inserted
    func loadImagesFromAssets(into scrollViews: [PinnableScrollView]) -> Int {
        var count = 0
        // Image names are "\(prefix)01", "\(prefix)02" etc.
        for (prefix, scrollView) in zip(imagePrefixes, scrollViews) {
            for suffixCount in 1... {
                let suffix = String(format: "%02d", suffixCount)
                let imageName = "\(prefix)\(suffix)"
                guard let image = UIImage(named: imageName) else { break }
                count += 1
                scrollView.insert(image: image).tag = -1
            }
        }
        return count
    }
    
    /// Load items from the server to Item.all array
    /// - Parameter gender: load female or male items only
    /// - Parameter completion: closure with bool parameter which is called with true in case of success, with false otherwise
    func loadItems(filteredBy gender: Gender, completion: @escaping (_ success: Bool?) -> Void) {
        let startTime = Date()
        let categories = Category.filtered(by: gender).flatMap { $0 }
        NetworkManager.shared.getOffers(inCategories: categories,
                                        filteredBy: gender,
                                        forVendors: BrandManager.shared.brandNames) { items in
            let endTime = Date()
            
            guard let items = items else {
                completion(nil)
                return
            }
            
            Item.append(contentsOf: items)
            
            let passedTime = endTime.timeIntervalSince1970 - startTime.timeIntervalSince1970
            
            debug(Item.all.count, "items are loaded from the server in", passedTime.asTime, "seconds")
            completion(true)
        }
    }
    
    /// Return image collection view models filetered by brands
    /// - Parameter brands: the names of the brands to filter view models by
    /// - Returns: image collection view model array
    func viewModels(branded brands: [String]) -> [ImageCollectionViewModel] {
        viewModels
    }
}
