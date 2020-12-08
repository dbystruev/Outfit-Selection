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
    
    /// Load images for some items in Item.all filtered by category in Category.all.count into scroll views
    /// - Parameters:
    ///   - brands: the names of the brands to filter images by
    ///   - scrollViews: scroll views to load images into, one scroll view for each category
    ///   - completion: closure with int parameter which is called when all images are processed, parameter holds the number of items loaded
    func loadImages(branded brands: [String] = [],
                    into scrollViews: [PinnableScrollView],
                    completion: @escaping (_ count: Int) -> Void) {
        /// Items remaining to load into scroll views
        var itemsRemaining = 0 {
            didSet {
                checkForCompletion(remaining: itemsRemaining, completion: completion)
            }
        }
        
        debug(brands)
        
        /// Loop all categories and scroll views, whatever number is lower
        for (category, scrollView) in zip(Category.all, scrollViews) {
            // Get Category.maxItemCount items in the given category
            let items = Item.all.filter({ $0.categoryId == category.id && $0.branded(brands) }).prefix(Category.maxItemCount)
            
            // Remember how many items we need to load
            itemsRemaining += items.count
            
            // The number of images in this category's scroll view
            var imagesInScrollView = scrollView.count
            
            // Delete all placeholder images from the beginning of scroll view
            while (0 < imagesInScrollView) {
                scrollView.deleteImageView(withIndex: 0)
                imagesInScrollView -= 1
            }
            
            // Loop all items in given category
            for item in items {
                guard let url = item.pictures?.first else {
                    // No picture — that's an error
                    debug("ERROR: No picture URLs for the item", item.name, item.url)
                    itemsRemaining -= 1
                    continue
                }
                
                // Try to get an image for current item
                NetworkManager.shared.getImage(url) { image in
                    // Didn't get the image — that's an error
                    guard let image = image else {
                        debug("ERROR: Can't get an image for the item", item.name, item.url)
                        itemsRemaining -= 1
                        return
                    }
                    
                    // No item index — that's an error
                    guard let itemIndex = item.itemIndex else  {
                        debug("ERROR: Can't get item index for the item", item.name, item.url)
                        itemsRemaining -= 1
                        return
                    }
                    
                    self.imagesLoaded += 1
                    
                    // Append image to the end of corresponding scroll view
                    DispatchQueue.main.async {
                        scrollView.insert(image: image.halved).tag = itemIndex
                        itemsRemaining -= 1
                    }
                }
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
    /// - Parameter gender: load female or male items only, both if nil
    /// - Parameter completion: closure with bool parameter which is called with true in case of success, with false otherwise
    func loadItems(filteredBy gender: Gender? = nil, completion: @escaping (_ success: Bool?) -> Void) {
        let startTime = Date()
        NetworkManager.shared.getOffers(inCategories: Category.all,
                                        filteredBy: gender,
                                        forVendors: BrandManager.shared.brandNames) { items in
            let endTime = Date()
            
            guard let items = items else {
                completion(nil)
                return
            }
            
            Item.append(contentsOf: items)
            
            let passedTime = endTime.timeIntervalSince1970 - startTime.timeIntervalSince1970
            
            debug(Item.all.count, "items are loaded from server in", passedTime.asTime, "seconds")
            completion(true)
        }
    }
}
