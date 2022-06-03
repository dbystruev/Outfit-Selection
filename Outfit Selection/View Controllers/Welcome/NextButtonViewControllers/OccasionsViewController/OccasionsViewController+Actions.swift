//
//  OccasionsViewController+Actions.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 11.10.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import UIKit

extension OccasionsViewController {
    // MARK: - Actions
    /// Call when leftBarButtonItem tapped
    @objc func cancelButtonTapped() {
        // Hide backButton
        navigationItem.hidesBackButton = true
        
        // Load selected occasions
        let occasions = Occasions.currentGender
        let selectedOccasionTitles  = UserDefaults.selectedOccasionTitles
        for occasion in occasions {
            occasion.isSelected = selectedOccasionTitles.contains(occasion.title)
        }
        
        // Set isEditing false
        setEditing(false, animated: false)
        
        // Return to called viewController
        navigationController?.popViewController(animated: true)
    }
    
    /// Call when Next Button tapped
    override func nextButtonTapped(_ sender: UIButton) {
        if isEditing {
            
            // isEditing set to false
            setEditing(false, animated: false)
            
            // Reload Items
            NetworkManager.shared.reloadItems(for: Gender.current) { _ in }
            
            // Save selected occasions
            Occasions.saveSelectedOccasions()
            
            // Post notification
            NotificationCenter.default.post(name: Notification.Name(Global.Notification.name.updatedOccasions), object: nil)
            
            // Back to profile viewController
            navigationController?.popViewController(animated: true)
            
        } else {
            // Start loading items
            NetworkManager.shared.reloadItems(for: Gender.current) { _ in }
            
            // The user has given answer for questions
            UserDefaults.hasAnswerQuestions = true
            
            // Transition to progress
            performSegue(withIdentifier: ProgressViewController.segueIdentifier, sender: sender)
        }
    }
    
    @IBAction func selectAllButtonTapped(_ sender: SelectableButtonItem) {
        // Switch the selection
        sender.isButtonSelected.toggle()
        let isSelected = sender.isButtonSelected
        
        // Select / deselect all occasions save the selection to permanent storage
        Occasions.byTitle.keys.forEach {
            Occasions.selectWithoutSaving(title: $0, shouldSelect: isSelected)
        }
        
        if isEditing {
            // If isEditing == true, will nothing happened
        } else {
            // Save selected occasions
            Occasions.saveSelectedOccasions()
        }
        
        // Reload occasions and enable / disable go button
        if AppDelegate.canReload && occasionsTableView?.hasUncommittedUpdates == false {
            occasionsTableView?.reloadData()
        }
        configureGoButton()
    }
}
