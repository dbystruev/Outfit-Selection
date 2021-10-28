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
    override func nextButtonTapped(_ sender: UIButton) {
        // Transition to occasions if they are not empty
        guard Occasions.byID.isEmpty else {
            performSegue(withIdentifier: OccasionsViewController.segueIdentifier, sender: sender)
            return
        }
        
        // Start loading items
        NetworkManager.shared.reloadItems(for: Gender.current) { _ in }
        
        // Transition to progress
        performSegue(withIdentifier: ProgressViewController.segueIdentifier, sender: sender)
    }
    
    @IBAction func selectAllButtonTapped(_ sender: SelectableButtonItem) {
        // Switch the selection
        sender.isButtonSelected.toggle()
        let isSelected = sender.isButtonSelected
        
        // Select / deselect all branded images and save the selection to permanent storage
        brandedImages.forEach { $0.isSelected = isSelected }
        BrandManager.shared.saveSelectedBrands()
        
        brandsCollectionView.reloadData()
        configureNextButton()
    }
}
