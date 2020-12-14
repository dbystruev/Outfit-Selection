//
//  BrandsViewController+Actions.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 13.12.2020.
//  Copyright © 2020 Denis Bystruev. All rights reserved.
//

import UIKit

// MARK: - Actions
extension BrandsViewController {
    @IBAction func goButtonTapped(_ sender: UIButton) {
        // Check that items were loaded, otherwise reload them
        guard allItemsLoaded else {
            configureItems()
            return
        }
        
        // Hide go button
        goButton.isEnabled = false
        goButton.setTitle("Loading images...", for: .disabled)
        
        // Find out where is the navigation controller
        var navigationController = presentingViewController as? UINavigationController
        if navigationController == nil {
            navigationController = presentingViewController?.presentingViewController as? UINavigationController
        }
        
        // Find out the root = outfit view controller
        let outfitViewController = navigationController?.viewControllers.first as? OutfitViewController
        
        // Get brand names to filter by
        let brandNames = brandedImages.compactMap { $0.isSelected ? $0.brandName : nil }
        
        // Load view models with the new images
        let startTime = Date().timeIntervalSince1970
        ItemManager.shared.loadImages(filteredBy: self.gender, andBy: brandNames) { itemsLoaded in
            let passedTime = Date().timeIntervalSince1970 - startTime
            
            debug(itemsLoaded, "images are loaded from the server into view models in", passedTime.asTime, "seconds")
            
            // Save selected brands (do not use brand names as the user could have changed the selection while waiting)
            outfitViewController?.brandNames = self.brandedImages.compactMap { $0.isSelected ? $0.brandName : nil }
            
            // Save brand images for future selection change
            BrandManager.shared.brandedImages = self.brandedImages
            
            DispatchQueue.main.async {
                // Load images into the outfit view controller's scroll views
                outfitViewController?.loadImages()
                
                self.dismissRoot(animated: true)
            }
        }
    }
}
