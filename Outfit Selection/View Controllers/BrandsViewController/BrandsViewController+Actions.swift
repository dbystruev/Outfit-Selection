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
    @IBAction func selectAllButtonTapped(_ sender: SelectableButtonItem) {
        // Switch the selection
        sender.isSelected.toggle()
        let isSelected = sender.isSelected
        
        // Select / deselect all branded images and save the selectionto permanent storage
        brandedImages.forEach { $0._isSelected = isSelected }
        BrandManager.shared.saveSelectedBrands()
        
        brandsCollectionView.reloadData()
        configureGoButton()
    }
    
    /// Called when Get Outfit button is tapped
    /// - Parameter sender: the get outfit button which was tapped
    @IBAction func getOutfitButtonTapped(_ sender: UIButton) {
        // Check that items were loaded, otherwise reload them
        guard allItemsLoaded else {
            configureItems()
            return
        }
        
        // Transition to the progress view controller
        performSegue(withIdentifier: OccasionsViewController.segueIdentifier, sender: sender)
    }
}
