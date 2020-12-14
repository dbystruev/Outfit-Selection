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
        guard allItemsLoaded else {
            configureItems()
            return
        }
        
        // Find out where is the navigation controller
        var navigationController = presentingViewController as? UINavigationController
        if navigationController == nil {
            navigationController = presentingViewController?.presentingViewController as? UINavigationController
        }
        
        // Find out the root = outfit view controller
        let outfitViewController = navigationController?.viewControllers.first as? OutfitViewController
        
        // Save selected brands
        outfitViewController?.brandNames = brandedImages.compactMap { $0.isSelected ? $0.brandName : nil }
        
        // Load images into the outfit view controller's sroll views
        outfitViewController?.loadImages()
        
        // Save brand images for future selection change
        BrandManager.shared.brandedImages = brandedImages
        
        dismissRoot(animated: true)
    }
}
