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
    /// Call when leftBarButtonItem tapped
    @objc func cancelButtonTap() {
        
        // Clear searchBar text
        searchBar.text = ""
        finishEditing(searchBar)
        
        // Set isEditing false
        setEditing(false, animated: false)
        
        // Restore saved brands
        Brands.update(selectedBrands: savedBrands)
    
        // Return to called viewController
        navigationController?.popViewController(animated: true)
    }
    
    /// Called when next button is tapped
    /// - Parameter sender: the get outfit button which was tapped
    override func nextButtonTapped(_ sender: UIButton) { 
        if isEditing {
            
            // Clear searchBar text
            searchBar.text = ""
            finishEditing(searchBar)
            
            // isEditing set to false
            setEditing(false, animated: false)
            
            // Reload Items
            NetworkManager.shared.reloadItems(for: Gender.current) { _ in }
            
            // Back to profile viewController
            navigationController?.popViewController(animated: true)
            
            // Post notification
            NotificationCenter.default.post(name: Notification.Name("BrandsChanged"), object: nil)
            
        } else {
            // Transition to occasions if they are not empty
            guard Occasions.areEmpty else {
                performSegue(withIdentifier: OccasionsViewController.segueIdentifier, sender: sender)
                return
            }
            
            // Start loading items
            NetworkManager.shared.reloadItems(for: Gender.current) { _ in }
            
            // Transition to progress
            performSegue(withIdentifier: ProgressViewController.segueIdentifier, sender: sender)
        }
    }
    
    @IBAction func selectAllButtonTapped(_ sender: SelectableButtonItem) {
        // Switch the selection
        sender.isButtonSelected.toggle()
        let isSelected = sender.isButtonSelected
        
        // Select / deselect all branded images and save the selection to permanent storage
        Brands.filtered.forEach { $0.value.select(isSelected: isSelected, updateUserDefaults: false) }
        Brands.saveSelectedBrands()
        
        brandsCollectionView.reloadData()
        configureNextButton()
    }
}
