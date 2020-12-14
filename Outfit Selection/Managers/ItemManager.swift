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
    
    /// Array of category image collection view models
    let viewModels: [ImageCollectionViewModel] = (0 ..< Category.all.count).map { _ in ImageCollectionViewModel.empty }
    
    // MARK: - Computed Properties
    /// Number of items loaded into view models
    var count: Int {
        viewModels.reduce(0) { $0 + $1.count }
    }
    
    // MARK: - Methods
    /// Clear all view models
    func clearViewModels() {
        viewModels.forEach { $0.removeAll() }
    }
    
    /// Load images filtered by categories into view models
    /// - Parameters:
    ///   - gender: gender to filter images by
    ///   - brandNames: brand names to filter images by
    ///   - completion: closure with int parameter which is called when all images are processed, parameter holds the number of items loaded
    func loadImages(filteredBy gender: Gender, andBy brandNames: [String], completion: @escaping (_ count: Int) -> Void) {
        // Clear all view models
        clearViewModels()
        
        // Create a dispatch group to stop when all images are loaded
        let group = DispatchGroup()
        
        /// Loop all categories and view models, whatever number is lower
        for (categories, viewModel) in zip(Category.filtered(by: gender), ItemManager.shared.viewModels) {
            // The names of the items already loaded in this category
            var loadedItemNames = [String]()
            
            // Get category identifiers
            let categoryIds = categories.map { $0.id }
            
            // Select only the items which belong to one of the categories given
            let categoryFilteredItems = Item.all.filter {
                // Check that the item has category id attached, else filter it out
                guard let itemCategoryId = $0.categoryId else { return false }
                
                // Check that item's category id is in the list of category ids looked for
                return categoryIds.contains(itemCategoryId)
            }
            
            // Filter category items by the brand given
            let brandFilteredItems = categoryFilteredItems.filter { $0.branded(brandNames) }
            
            // If brand filtering brought us an empty list, discard it
            let items = brandFilteredItems.isEmpty ? categoryFilteredItems : brandFilteredItems
            
            // The maximum number of network image loads in one corner
            var remainingLoads = Category.maxItemCount
            
            // Loop all items in given category
            for item in items {
                // Don't load items with names similar to already loaded
                guard let itemName = item.name else {
                    // No item name - that's an error
                    debug("ERROR: no item name for item in categories \(categories)")
                    continue
                }
                
                // Check that there is no item with the same name already in the list
                guard !loadedItemNames.contains(itemName) else {
                    // Items with similar names - that's not an error, but a warning
                    //debug("WARNING: \(itemName) already loaded in category \(category.name)")
                    continue
                }
                
                // Get the item picture url
                guard let pictureURL = item.pictures?.first else {
                    // No picture — that's an error
                    debug("ERROR: No picture URLs for the item", item.name, item.url)
                    continue
                }
                
                // Check that we haven't used the maximum number of network loads in the category
                guard 0 < remainingLoads else { continue }
                remainingLoads -= 1
                
                // Pretend that we have succesfully loaded an item with given name
                loadedItemNames.append(itemName)
                
                // Enter the dispatch group for the next get image request
                group.enter()
                
                // Try to get an image for the current item
                NetworkManager.shared.getImage(pictureURL) { optionalImage in
                    // Make sure we always leave the group
                    defer { group.leave() }
                    
                    // Didn't get the image — that's an error
                    guard let image = optionalImage, let itemIndex = item.itemIndex else {
                        // Compose error message
                        let message = optionalImage == nil ? "image" : "item index"
                        
                        debug("ERROR: Can't get an \(message) for the item", item.name, item.url)
                        
                        // Remove item name already added to the array of loaded item names
                        if let itemNameIndex = loadedItemNames.firstIndex(of: itemName) {
                            loadedItemNames.remove(at: itemNameIndex)
                        }
                        
                        // Increase remaining loads
                        remainingLoads += 1
                        
                        return
                    }
                    
                    // Append image to the end of corresponding image collection view model
                    viewModel.append(image.halved, tag: itemIndex, vendor: item.vendor)
                }
            }
        }
        
        // Get here when all image network requests are finished
        group.notify(queue: DispatchQueue.global(qos: .background)) {
            completion(self.count)
        }
    }
    
    /// Load images from view models into scroll views
    /// - Parameters:
    ///   - scrollViews: scroll views to load images into, one scroll view for each category
    func loadImages(into scrollViews: [PinnableScrollView]) {
        /// Loop all view models and scroll views, whatever number is lower
        for (viewModel, scrollView) in zip(ItemManager.shared.viewModels, scrollViews) {
            // Loop all items in given category filtered by brands
            for index in 0 ..< viewModel.count {
                let image = viewModel[index]
                scrollView.insert(image: image).tag = image.tag
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
