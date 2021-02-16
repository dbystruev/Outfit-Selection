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
    @IBAction func clearAllButtonTapped(_ sender: UIBarButtonItem) {
        brandedImages.forEach {
            $0.isSelected = false
        }
        brandsCollectionView.reloadData()
    }
    
    /// Called when Get Outfit button is tapped
    /// - Parameter sender: the get outfit button which was tapped
    @IBAction func getOutfitButtonTapped(_ sender: UIButton) {
        // Check that items were loaded, otherwise reload them
        guard allItemsLoaded else {
            configureItems()
            return
        }
        
        // Hide go button
        getOutfitButton.isEnabled = false
        getOutfitButton.setTitle("Loading images...", for: .disabled)
        
        // Instantiate the Outfit View Controller
        let controller = storyboard?.instantiateViewController(withIdentifier: "OutfitViewController")
        guard let outfitViewController = controller as? OutfitViewController else {
            debug("WARNING: Can't get Outfit View Controller from Storyboard", storyboard)
            return
        }
        
        // Copy gender to Outfit View Controller
        outfitViewController.gender = gender ?? .other
        
        // Get brand names to filter by
        let brandNames = brandedImages.compactMap { $0.isSelected ? $0.brandName : nil }
        
        // Load view models with the new images
        let startTime = Date().timeIntervalSince1970
        ItemManager.shared.loadImages(filteredBy: self.gender, andBy: brandNames) { itemsLoaded in
            let passedTime = Date().timeIntervalSince1970 - startTime
            
            debug(itemsLoaded, "images are loaded from the server into view models in", passedTime.asTime, "seconds")
            
            // Save selected brands (do not use brand names as the user could have changed the selection while waiting)
            outfitViewController.brandNames = self.brandedImages.compactMap { $0.isSelected ? $0.brandName : nil }
            
            // Save brand images for future selection change
            BrandManager.shared.brandedImages = self.brandedImages
            
            DispatchQueue.main.async {
                self.navigationController?.pushViewController(outfitViewController, animated: true)
                self.getOutfitButton.isEnabled = true
                self.getOutfitButton.setTitle("Get Outfit", for: .normal)
            }
        }
    }
}
