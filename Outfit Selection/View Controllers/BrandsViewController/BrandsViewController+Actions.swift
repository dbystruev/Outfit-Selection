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
        sender.isButtonSelected.toggle()
        let isSelected = sender.isButtonSelected
        
        // Select / deselect all branded images and save the selectionto permanent storage
        brandedImages.forEach { $0._isSelected = isSelected }
        BrandManager.shared.saveSelectedBrands()
        
        brandsCollectionView.reloadData()
        configureGoButton()
    }
    
    /// Called when Get Outfit button is tapped
    /// - Parameter sender: the get outfit button which was tapped
    @IBAction func getOutfitButtonTapped(_ sender: UIButton) {
        // Start loading items
        NetworkManager.shared.reloadItems(for: gender) { _ in }
        
        // Transition to the progress view controller
        performSegue(withIdentifier: OccasionsViewController.segueIdentifier, sender: sender)
    }
}
