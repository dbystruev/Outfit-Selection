//
//  ItemManager.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 23.11.2020.
//  Copyright © 2020 Denis Bystruev. All rights reserved.
//

import UIKit

/// Class responsible for item loads
final class ItemManager {
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
    let viewModels: [ImageCollectionViewModel] = (0 ..< Corners.count).map { _ in
        ImageCollectionViewModel.empty
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
    
    /// Check all itemIDs
    /// - Parameters:
    ///   - itemIDs: string array with IDs
    func checkItemsByID(_ itemIDs: [String], completion: @escaping (Items?) -> Void)  {
        DispatchManager.shared.itemManagerGroup.enter()
        NetworkManager.shared.getItems(itemIDs) { items in
            
            // Make sure we always leave the group
            defer {
                DispatchManager.shared.itemManagerGroup.leave()
            }
            
            guard let items = items else {
                completion(nil)
                return
            }
            
            // Back to the main thread
            DispatchQueue.main.async {
                completion(items)
            }
        }
    }
    
    /// Load images filtered by categories into view models
    /// - Parameters:
    ///   - items: items to for download images
    func loadImagesFromItems(
        items: Items,
        completion: @escaping () -> Void
    ) {
        
        // Remove all items before loading new items
        Items.removeAll()
        
        // Count elapsed time
        let startTime = Date()
        
        // Clear all view models
        clearViewModels()
        
        // Dispatch group to wait for all loads to finish
        let group = DispatchGroup()
        // Go through all items and load images one by one
        
        DispatchQueue.global(qos: .background).async {

            // var itemsSkipped = 0
            for (item, viewModel) in zip(items, self.viewModels ) {
                
                // Get the item picture url
                guard let pictureURL = item.pictures.first else {
                    debug("ERROR: No picture URLs for the item", item, item.url)
                    continue
                }
                
                group.enter()
                NetworkManager.shared.getImage(pictureURL) { image in
                    // Check for self availability
                    guard let image = image else {
                        debug("ERROR: self is not available")
                        group.leave()
                        return
                    }
                    
                    // Append image to the view model
                    viewModel.append(image.halved, item: item)
//                    debug("Added item ID:", viewModel.items.IDs, "into viewModel" )
                    group.leave()
                }
            }
            
            // Get here when all image network requests are finished
            group.notify(
                queue: DispatchQueue.global(qos: .background)
            ) {
                
                // Return to main thead and run completion
                DispatchQueue.main.async {
                    completion()
                }
                
                // Show stats when all loads are finished
                let elapsedTime = Date().timeIntervalSince(startTime)
                debug("Loaded", self.count, "images in \(elapsedTime.asTime) s")
            }
            
        }
    }
    
    /// Load images filtered by categories into view models
    /// - Parameters:
    ///   - gender: gender to filter images by
    ///   - brandNames: brand names to filter images by
    ///   - limit: the number of images to load in each corner per occasion with selected title, Items.maxCornerCount by default
    ///   - continueLoading: the process of loading remaining images in background continues, false by default
    ///   - completion: (int, int) closure called while images are processed, gets current and total number of items loaded
    func loadImages(
        filteredBy gender: Gender?,
        andBy brandNames: [String] = [],
        cornerLimit limit: Int = Items.maxCornerCount,
        completion: @escaping (_ current: Int, _ total: Int) -> Void
    ) {
        // Count elapsed time
        let startTime = Date()
        
        // Clear all view models
        clearViewModels()
        
        // Move everything to async queue in order not to hang execution
        DispatchQueue.global(qos: .background).async {
            
            // Wait for network group load items to finish
            DispatchManager.shared.itemManagerGroup.wait()
            
            // Counts for progress view update
            var current = 0
            var total = 0
            
            // Save loaded items
            let itemsToLoad = Items.values
            
            // Generate categories or subcategories from occasions
            let occasionsSelectedForGender = limit == 1
            ? [Occasion.selected].compactMap { $0 }
            : Occasions.selected.gender(gender)
            let useOccasions = !occasionsSelectedForGender.areEmpty
            let categoriesByCorner = useOccasions
            ? Categories.by(occasions: occasionsSelectedForGender)
            : Categories.by(gender: gender)
            
            /// Loop all corners
            var itemsSkipped = 0
            for (categories, viewModel) in zip(categoriesByCorner, self.viewModels) {
                // The names of the items already loaded in this corner
                var loadedItemNames = [String]()
                
                // Get category identifiers
                let categoryIDs = categories.IDs
                
                // Select only the items which belong to one of the categories given
                let categoryFilteredItems = useOccasions
                ? itemsToLoad.matching(subcategoryIDs: categoryIDs)
                : itemsToLoad.matching(categoryIDs: categoryIDs)
                
                // Filter category filtered items by the brand given
                let brandFilteredItems = categoryFilteredItems.filter { item in
                    item.wishlisted == true || item.branded(brandNames)
                }
                
                // If brand filtering brought us an empty list, discard it
                let items = brandFilteredItems.isEmpty ? categoryFilteredItems : brandFilteredItems
                
                // Select the limited number of random items
                let itemsToLoadImmediately = limit < items.count
                ? items.randomSample(count: limit)
                : items
                
                // Remember item IDs to load after immediate items are loaded
                let itemIDsToLoadImmediately = itemsToLoadImmediately.IDs
                let itemIDsToLoadInBackground = items.IDs.filter { !itemIDsToLoadImmediately.contains($0) }
                
                // The maximum number of network image loads in one corner
                var remainingLoads = limit
                
                // Loop all items in given category
                for item in itemsToLoadImmediately {
                    // Check that there is no item with the same name already in the list, unless it is wishlisted
                    guard item.wishlisted || !loadedItemNames.contains(item.name) else {
                        // Skip items with similar names
                        itemsSkipped += 1
                        continue
                    }
                    
                    // Get the item picture url
                    guard let pictureURL = item.pictures.first else {
                        // No picture — that's an error
                        debug("ERROR: No picture URLs for the item", item, item.url)
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
                    NetworkManager.shared.getImage(pictureURL) { [weak self] optionalImage in
                        // Make sure we always leave the group
                        defer { DispatchManager.shared.itemManagerGroup.leave() }
                        
                        // Check for self availability
                        guard let self = self else {
                            debug("ERROR: self is not available")
                            return
                        }
                        
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
                        
                        // Load other images in background
                        self.loadImagesInBackground(for: itemIDsToLoadInBackground, into: viewModel)
                        
                        // Update the number of currently loaded images
                        current += 1
                        
                        // Update progress bar, but avoid final update
                        if current < total {
                            completion(current, total)
                        }
                    }
                }
            }
            
            // Items with similar names - that's not an error, but a warning
            if 0 < itemsSkipped {
                debug("WARNING: Similar items skipped: \(itemsSkipped)")
            }
            
            // Get here when all image network requests are finished
            DispatchManager.shared.itemManagerGroup.notify(
                queue: DispatchQueue.global(qos: .background)
            ) {
                // Filter out occasions without images in view models
                //                Occasions.filter(by: self.viewModels.corneredItems)
                
                completion(self.count, self.count)
                
                let elapsedTime = Date().timeIntervalSince(startTime)
                debug("Loaded", self.count, gender, "images in \(elapsedTime.asTime) s")
            }
        }
    }
    
    /// Load images for given item IDs into view models
    /// - Parameters:
    ///   - itemIDs: IDs for items to load images for
    ///   - viewModel: view model to load the images into
    func loadImagesInBackground(for itemIDs: [String], into viewModel: ImageCollectionViewModel) {
        // Count elapsed time
        let startTime = Date()
        
        // Dispatch group to wait for all loads to finish
        let group = DispatchGroup()
        
        // Loaded / skipped items count
        var itemsLoaded = 0
        
        // Go through all items and load images one by one
        DispatchQueue.global(qos: .background).async {
            for itemID in itemIDs {
                // Get item image URL or skip
                guard
                    let item = itemID.item,
                    let pictureURL = item.pictures.first
                else { continue }
                
                group.enter()
                NetworkManager.shared.getImage(pictureURL) { image in
                    // Check that we've got the actual image
                    guard let image = image else {
                        group.leave()
                        return
                    }
                    
                    // Append image to the view model
                    viewModel.append(image.halved, item: item)
                    itemsLoaded += 1
                    group.leave()
                }
                
                group.wait()
                // debug("Loaded", itemsLoaded, "of", itemIDs.count)
            }
            
            // Show stats when all loads are finished
            let elapsedTime = Date().timeIntervalSince(startTime)
            debug("INFO: loaded \(itemsLoaded), skipped \(itemIDs.count - itemsLoaded)",
                  "of \(itemIDs.count) images in \(elapsedTime.asTime) s")
        }
    }
    
    /// Load images from view models into scroll views
    /// - Parameters:
    ///   - scrollViews: scroll views to load images into, one scroll view for each category
    ///   - corneredSubcategoryIDs: subcategory IDs from occasion
    func loadImages(into scrollViews: PinnableScrollViews, matching corneredSubcategoryIDs: [[Int]] = Corners.empty) {
        // Loop all view models, scroll views, and subcategory IDs, whatever number is lower
        for (viewModel, (scrollView, subcategoryIDs)) in zip(viewModels, zip(scrollViews, corneredSubcategoryIDs)) {
            // Loop all items in given category filtered by brands
            for index in 0 ..< viewModel.count {
                // Skip images which do not have associated items
                let image = viewModel[index]
                guard let item = image.item else { continue }
                
                // Skip items which do not have matching subcategories
                guard subcategoryIDs.isEmpty || item.isMatching(subcategoryIDs) else { continue }
                
                // Inset image into scroll view
                scrollView.insert(image: image).displayedItem = image.item
            }
        }
    }
    
    /// Load items from the server to Item.all array
    /// - Parameters:
    ///   - occasion: occasion to load the items for
    ///   - completion: closure with bool parameter which is called with true in case of success, with false otherwise
    func loadItems(
        for occasion: Occasion?,
        completion: @escaping (_ success: Bool?) -> Void
    ) {
        // Check that occasion is not nil
        guard let occasion = occasion else {
            completion(false)
            return
        }
        
        // Measure the number of requests and elapsed time
        currentRequest = 0
        let startTime = Date()
        
        // Assume all requests went fine until told otherwise
        success = true
        
        // Remove all items before loading them again
        Items.removeAll()
        
        /// Count the number of (sub)categories for loaded items
        var categoriesCount = 0
        
        // Occasion item IDs from top left clockwise matching cornered subcategory IDs
        let corneredItemIDs = occasion.corneredItemIDs
        
        /// The total number of requests
        let totalRequests = corneredItemIDs.count
        
        // Go through each corner and load items IDs for the occasion
        for itemIDs in corneredItemIDs {
            loadItemsByID(itemIDs, totalRequests: totalRequests, subcategoriesCount: &categoriesCount)
        }
        
        // Complete when all dispatch group tasks are finished
        DispatchManager.shared.itemManagerGroup.notify(queue: .global(qos: .background)) {
            let endTime = Date()
            let passedTime = endTime.timeIntervalSince1970 - startTime.timeIntervalSince1970
            
            if self.success {
                debug(
                    Items.count, "items for occasion", occasion,
                    "loaded in \(passedTime.asTime) s"
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
        let chunkSize = selectedBrandNames.count * totalRequests / NetworkManager.shared.requestsRecommended + 1
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
            ) { [weak self] items in
                // Check for self availability
                guard let self = self else {
                    debug("ERROR: self is not available")
                    return
                }
                
                // Check if any items were loaded
                if let items = items {
                    Items.append(contentsOf: items)
                } else {
                    self.success = false
                }
                
                DispatchManager.shared.itemManagerGroup.leave()
                
                // Update progress bar
                self.currentRequest += 1
                self.updateProgressBar(currentRequest: self.currentRequest, totalRequests: totalRequests)
            }
        }
    }
    
    /// Load items from the server and append them to Item.all
    /// - Parameters:
    ///   - itemIDs: the list of item IDs to load
    ///   - totalRequests: the total number of parallel calls to this function, nil by default
    ///   - subcategoriesCount: inout counter of loaded item's subcategories, nil by default
    func loadItemsByID(
        _ itemIDs: [String],
        totalRequests: Int? = nil,
        subcategoriesCount: UnsafeMutablePointer<Int>? = nil
    ) {
        DispatchManager.shared.itemManagerGroup.enter()
        NetworkManager.shared.getItems(itemIDs) { [weak self] items in
            defer {
                DispatchManager.shared.itemManagerGroup.leave()
            }
            
            // Check for self availability
            guard let self = self else {
                debug("ERROR: self is not available")
                return
            }
            
            // Check if any items were loaded
            if let items = items {
                Items.append(contentsOf: items)
                subcategoriesCount?.pointee = items.flatSubcategoryIDs.count
            } else {
                self.success = false
                subcategoriesCount?.pointee = 0
            }
            
            // Update progress bar
            if let totalRequests = totalRequests {
                self.currentRequest += 1
                self.updateProgressBar(currentRequest: self.currentRequest, totalRequests: totalRequests)
            }
        }
    }
    
    /// Update progress bar in progress view controller
    /// - Parameters:
    ///   - currentRequest: the number of current request
    ///   - totalRequests: the total number of parallel calls
    func updateProgressBar(currentRequest: Int, totalRequests: Int) {
        ProgressViewController.default?.updateProgressBar(
            current: currentRequest,
            total: totalRequests,
            maxValue: 0.5
        )
    }
    
    /// Return image collection view models filetered by brands
    /// - Parameter brands: the names of the brands to filter view models by
    /// - Returns: image collection view model array
    func viewModels(branded brands: [String]) -> [ImageCollectionViewModel] {
        // TODO: Filter view models by brands
        viewModels
    }
}
