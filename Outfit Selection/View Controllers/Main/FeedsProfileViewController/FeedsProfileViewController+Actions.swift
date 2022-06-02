//
//  FeedsProfileViewController+Actions.swift
//  Outfit Selection
//
//  Created by Evgeniy Goncharov on 05.05.2022.
//  Copyright © 2022 Denis Bystruev. All rights reserved.
//

import UIKit

extension FeedsProfileViewController {
    // MARK: - Actions
    /// Call when leftBarButtonItem tapped
    @objc func cancelButtonTapped() {
        // Hide backButton
        navigationItem.hidesBackButton = true
        
        // Restore selected feedsSource
        FeedsProfile.restore()
        
        // Return to called viewController
        navigationController?.popViewController(animated: true)
    }
    
    /// Call when save button  tapped
    @IBAction func saveButtonTapped() {
        if feedProfileSelectedFeedsIDs != [String](FeedsProfile.all.selected.feedsIDs) {
            // Save selected feeds to user default
            FeedsProfile.save()
            // Post notification with name
            Global.Notification.notificationCenter.post(
                name: Notification.Name(nameNotification),
                object: nil
            )
        }
        
        // Back to profile viewController
        navigationController?.popViewController(animated: true)
    }
    
    /// Call when selected all tapped
    @IBAction func selectAllButtonTapped(_ sender: SelectableButtonItem) {
        // Switch the selection
        sender.isButtonSelected.toggle()
        let isSelected = sender.isButtonSelected
        
        // Select / deselect all occasions save the selection to permanent storage
        for (index ,name) in FeedsProfile.all.names.enumerated() {
            guard let feed = FeedsProfile.all.first(where: { $0.name == name }) else { return }
            
            // Set isSelected for CheckBox but without save it
            FeedsProfile.selectWithoutSaving(feed: feed, shouldUse: isSelected )
            
            // Find cell and IndexPath for it
            let cell = feedsTableView.visibleCells[index]
            guard let indexPath = feedsTableView.indexPath(for: cell) else { return }
            
            // Will be sure that UITableView cell is FeedsProfileCell
            guard let feedsProfileCell = feedsTableView.cellForRow(at: indexPath) as? FeedsProfileCell else {
                debug("ERROR: Can't cast tableView cell as", FeedsProfileCell.className)
                return
            }
            
            // Configure CheckBox and set isHighlighted
            feedsProfileCell.configureCheckBox(isHighlighted: feed.shouldUse)
        }

        configureAllButton()
        configureSaveButton()
    }
}
