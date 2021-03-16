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
        sender.isSelected.toggle()
        
        let isSelected = sender.isSelected
        sender.title = isSelected ? "Clear all" : "Select all"
        
        brandedImages.forEach {
            $0.isSelected = isSelected
        }
        
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
        performSegue(withIdentifier: "ProgressViewControllerSegue", sender: sender)
    }
}
