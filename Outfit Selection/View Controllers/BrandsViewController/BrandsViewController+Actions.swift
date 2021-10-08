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
    /// Called when next button is tapped
    /// - Parameter sender: the get outfit button which was tapped
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        // Start loading items
        NetworkManager.shared.reloadItems(for: gender) { _ in }
        
        // Transition progress view controller if occasions are empty
        guard !Occasion.all.isEmpty else {
            performSegue(withIdentifier: ProgressViewController.segueIdentifier, sender: sender)
            return
        }
        
        // Transition to occasions
        performSegue(withIdentifier: OccasionsViewController.segueIdentifier, sender: sender)
    }
    
    @IBAction func selectAllButtonTapped(_ sender: SelectableButtonItem) {
        // Switch the selection
        sender.isButtonSelected.toggle()
        let isSelected = sender.isButtonSelected
        
        // Select / deselect all branded images and save the selectionto permanent storage
        brandedImages.forEach { $0.isSelected = isSelected }
        BrandManager.shared.saveSelectedBrands()
        
        brandsCollectionView.reloadData()
        configureGoButton()
    }
}
