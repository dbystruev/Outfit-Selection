//
//  ItemManager.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 23.11.2020.
//  Copyright © 2020 Denis Bystruev. All rights reserved.
//

import UIKit

class ItemManager {
    // imagePrefixes should correspond to scrollViews
    let imagePrefixes = ["TopLeft", "BottomLeft", "TopRight", "MiddleRight", "BottomRight"]
    
    static let shared = ItemManager()
    private init() {}
    
    /// Call completion closure if all categories and all items were looped through
    /// - Parameters:
    ///   - success: true if there were no single error while loading items' images
    ///   - itemsRemaining: the number of items in category remaining to loop through
    ///   - completion: closure with bool parameter which is called when there are no categories and items remaining
    func checkForCompletion(_ success: Bool, items: Int, completion: @escaping (_ success: Bool?) -> Void) {
        if items < 1 {
            completion(success)
        }
    }
    
    /// Load images for all items in Item.all filtered by category in Category.all.count into scroll views
    /// - Parameters:
    ///   - scrollViews: scroll views to load images into, one scroll view for each category
    ///   - completion: closure with bool parameter which is called when all images are processed, parameter is true if no errors were encountered
    func loadImages(into scrollViews: [PinnableScrollView], completion: @escaping (_ success: Bool?) -> Void) {
        /// Items remaining to load into scroll views
        var itemsRemaining = Item.all.count {
            didSet {
                checkForCompletion(success, items: itemsRemaining, completion: completion)
            }
        }
        
        /// True if there were no errors so far while loading images
        var success = true
        
        /// Loop all categories and scroll views, whatever number is lower
        for (category, scrollView) in zip(Category.all, scrollViews) {
            // Get all items in the given category
            let items = Item.all.filter { $0.categoryId == category.id }
            
            // The number of images in this category's scroll view
            var imagesInScrollView = scrollView.count
            
            // Loop all items in given category
            for item in items {
                guard let url = item.pictures?.first else {
                    // No picture — that's an error
                    debug("ERROR: No picture URLs for the item", item.name, item.url)
                    success = false
                    itemsRemaining -= 1
                    continue
                }
                
                // Try to get an image for current item
                NetworkManager.shared.getImage(url) { image in
                    // Didn't get the image — that's an error
                    guard let image = image else {
                        debug("ERROR: Can't get an image for the item", item.name, item.url)
                        success = false
                        itemsRemaining -= 1
                        return
                    }
                    
                    // No item index — that's an error
                    guard let itemIndex = item.itemIndex else  {
                        debug("ERROR: Can't get item index for the item", item.name, item.url)
                        success = false
                        itemsRemaining -= 1
                        return
                    }
                    
                    // Append image to the end of corresponding scroll view
                    DispatchQueue.main.async {
                        scrollView.insert(image: image).tag = itemIndex
                        scrollView.scrollToLastElement() {_ in
                            // Delete one placeholder image from the beginning of scroll view with each insertion
                            if (0 < imagesInScrollView) {
                                scrollView.deleteImageView(withIndex: 0)
                                imagesInScrollView -= 1
                            }
                            itemsRemaining -= 1
                        }
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
    /// - Parameter completion: closure with bool parameter which is called with true in case of success, with false otherwise
    func loadItems(completion: @escaping (_ success: Bool?) -> Void) {
        let startTime = Date()
        NetworkManager.shared.getOffers(in: Category.all) { items in
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
