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
    /// Currently running request number for updating progress bar
    private var currentRequest = 0
    
    /// All item load requests success status
    private var success = true
    
    /// Array of category image collection view models
    let viewModels: [ImageCollectionViewModel] = (0 ..< Categories.all.count).map { _ in ImageCollectionViewModel.empty
    }
    
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
    func loadImages(
        filteredBy gender: Gender?,
        andBy brandNames: [String] = [],
        completion: @escaping (_ current: Int, _ total: Int) -> Void
    ) {
        // Clear all view models
        clearViewModels()
        
        // Get all wishlist items
        let allWishlistItems = Wishlist.allItems
        
        // Move everything to async queue in order not to hang execution
        DispatchQueue.global(qos: .background).async {
            
            // Wait for network group load images to finish
            DispatchManager.shared.itemManagerGroup.wait()
            
            // Counts for progress view update
            var current = 0
            var total = 0
            
            /// Loop all categories and view models, whatever number is lower
            for (categories, viewModel) in zip(Categories.filtered(by: gender), ItemManager.shared.viewModels) {
                // The names of the items already loaded in this category
                var loadedItemNames = [String]()
                
                // Get category identifiers
                let categoryIds = categories.ids
                
                // Select only the items which belong to one of the categories given
                let categoryFilteredItems = (allWishlistItems + Item.all.values).filter {
                    // Check that item's category id is in the list of category ids looked for
                    categoryIds.contains($0.categoryID)
                }
                
                // Filter category items by the brand given
                let brandFilteredItems = categoryFilteredItems.filter { $0.wishlisted == true || $0.branded(brandNames) }
                
                // If brand filtering brought us an empty list, discard it
                let items = brandFilteredItems.isEmpty ? categoryFilteredItems : brandFilteredItems
                
                // The maximum number of network image loads in one corner
                var remainingLoads = Categories.maxCornerCount
                
                // Loop all items in given category
                for item in items {
                    // Check that there is no item with the same name already in the list, unless it is wishlisted
                    guard !loadedItemNames.contains(item.name) else {
                        // Items with similar names - that's not an error, but a warning
                        //debug("WARNING: \(itemName) already loaded in category \(category.name)")
                        continue
                    }
                    
                    // Get the item picture url
                    guard let pictureURL = item.pictures.first else {
                        // No picture — that's an error
                        debug("ERROR: No picture URLs for the item", item.name, item.url)
                        continue
                    }
                    
                    // Check that we haven't used the maximum number of network loads in the category
                    guard 0 < remainingLoads else { continue }
                    remainingLoads -= 1
                    
                    // Pretend that we have succesfully loaded an item with given name
                    loadedItemNames.append(item.name)
                    
                    // Enter the dispatch group for the next get image request
                    DispatchManager.shared.itemManagerGroup.enter()
                    
                    // Update the number of total images
                    total += 1
                    
                    // Try to get an image for the current item
                    NetworkManager.shared.getImage(pictureURL) { optionalImage in
                        // Make sure we always leave the group
                        defer { DispatchManager.shared.itemManagerGroup.leave() }
                        
                        // Didn't get the image — that's an error
                        guard let image = optionalImage else {
                            // Compose error message
                            let message = optionalImage == nil ? "image" : "item index"
                            
                            debug("ERROR: Can't get an \(message) for the item", item.name, item.url)
                            
                            // Remove item name already added to the array of loaded item names
                            if let itemNameIndex = loadedItemNames.firstIndex(of: item.name) {
                                loadedItemNames.remove(at: itemNameIndex)
                            }
                            
                            // Increase remaining loads
                            remainingLoads += 1
                            
                            return
                        }
                        
                        // Append image to the end of corresponding image collection view model
                        viewModel.append(image.halved, item: item)
                        
                        // Update the number of currently loaded images
                        current += 1
                        
                        // Update progress bar, but avoid final update
                        if current < total {
                            completion(current, total)
                        }
                    }
                }
            }
            
            // Get here when all image network requests are finished
            DispatchManager.shared.itemManagerGroup.notify(queue: DispatchQueue.global(qos: .background)) {
                completion(self.count, self.count)
            }
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
                scrollView.insert(image: image).item = image.item
            }
        }
    }
    
    /// Load items from the server to Item.all array
    /// - Parameter gender: load female, male or other items only
    /// - Parameter completion: closure with bool parameter which is called with true in case of success, with false otherwise
    func loadItems(for gender: Gender?, completion: @escaping (_ success: Bool?) -> Void) {
        // Measure the number of requests and elapsed time
        currentRequest = 0
        let startTime = Date()
        
        // Assume all requests went fine until told otherwise
        success = true
        
        // Remove all items before loading them again
        Item.removeAll()
        
        // Make sure we don't forget wishlist items
        let allWishlistItemsIds = Array(Wishlist.allItemsIdSet)
        DispatchManager.shared.itemManagerGroup.enter()
        
        // Run network requests for different corners and brand names in parallel
        let categoriesCount: Int
        if Occasions.byID.isEmpty {
            let categoriesByCorners = Categories.filtered(by: gender)
            categoriesCount = categoriesByCorners.flatMap { $0.ids }.unique.count
            for categories in categoriesByCorners {
                loadItemsByBrands(
                    gender: gender,
                    categoryIDs: categories.ids.unique,
                    totalRequests: categoriesByCorners.count
                )
            }
        } else {
            let subcategoryIDsByOccasions = Occasions.selected.flatMap { $0.looks }
            categoriesCount = subcategoryIDsByOccasions.flatMap { $0 }.unique.count
            for subcategoryIDs in subcategoryIDsByOccasions {
                loadItemsByBrands(
                    gender: gender,
                    subcategoryIDs: subcategoryIDs.unique,
                    totalRequests: subcategoryIDsByOccasions.count
                )
            }
        }
        
        // Run network request for wishlist items in parallel
        NetworkManager.shared.getItems(allWishlistItemsIds) { itemsFromWishlists in
            // Check if any items were loaded
            if let itemsFromWishlists = itemsFromWishlists {
                Item.append(contentsOf: itemsFromWishlists)
            } else {
                self.success = false
            }
            
            DispatchManager.shared.itemManagerGroup.leave()
        }
        
        // Complete when all dispatch group tasks are finished
        DispatchManager.shared.itemManagerGroup.notify(queue: .main) {
            let endTime = Date()
            let passedTime = endTime.timeIntervalSince1970 - startTime.timeIntervalSince1970
            
            if self.success {
                debug(
                    Item.all.count,
                    gender?.rawValue,
                    "items from \(categoriesCount) categories loaded in",
                    passedTime.asTime,
                    "s"
                )
            }
            
            completion(self.success)
        }
    }
    
    /// Load items from the server to Item.all arrays, send requests for brands in parallel
    /// - Parameters:
    ///   - gender: load female. male, or other (all) items
    ///   - categoryIDs: the list of category IDs to filter items by, empty (all categories) by default
    ///   - subcategoryIDs: the list of subcategory IDs to filter items by, empty (all subcategories) by default
    ///   - currentRequest: request number currently running
    ///   - totalRequests: the total number of parallel calls to this function
    func loadItemsByBrands(
        gender: Gender?,
        categoryIDs: [Int] = [],
        subcategoryIDs: [Int] = [],
        totalRequests: Int
    ) {
        let selectedBrandNames = BrandManager.shared.selectedBrandNames
        let chunkSize = selectedBrandNames.count * totalRequests / 16 + 1
        let brandNamesSlice = selectedBrandNames.chunked(into: chunkSize)
        
        // Adjust current and total requests to the number of total requests
        let totalRequests = brandNamesSlice.count * totalRequests
        
        for brandNames in brandNamesSlice {
            DispatchManager.shared.itemManagerGroup.enter()
            NetworkManager.shared.getItems(
                for: gender,
                in: categoryIDs,
                subcategoryIDs: subcategoryIDs,
                filteredBy: brandNames
            ) { items in
                // Check if any items were loaded
                if let items = items {
                    Item.append(contentsOf: items)
                } else {
                    self.success = false
                }
                
                DispatchManager.shared.itemManagerGroup.leave()
                
                // Update progress bar
                self.currentRequest += 1
                ProgressViewController.default?.updateProgressBar(
                    current: self.currentRequest,
                    total: totalRequests, maxValue: 0.5
                )
            }
        }
    }
    
    /// Return image collection view models filetered by brands
    /// - Parameter brands: the names of the brands to filter view models by
    /// - Returns: image collection view model array
    func viewModels(branded brands: [String]) -> [ImageCollectionViewModel] {
        viewModels
    }
}
