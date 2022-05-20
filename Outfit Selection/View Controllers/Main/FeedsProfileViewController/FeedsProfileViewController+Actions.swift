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
    @objc func cancelButtonTap() {
        // Hide backButton
        navigationItem.hidesBackButton = true
        
        // Restore selected feedsSource
        FeedsProfile.restore()
        
        // Return to called viewController
        navigationController?.popViewController(animated: true)
    }
    
    /// Call when save button  tapped
    @IBAction func saveButtonTap() {
        
        if feedProfileSelectedFeedsIDs != [String](FeedsProfile.all.selected.feedsIDs) {
            // Save selected feeds to user default
            FeedsProfile.save()
            // Post notification with name
            Globals.Notification.notificationCenter.post(
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
        for name in FeedsProfile.all.names {
            guard let feed = FeedsProfile.all.first(where: { $0.name == name }) else { return }
            FeedsProfile.selectWithoutSaving(feed: feed, shouldUse: isSelected )
        }
        
        // Reload feeds and enable / disable go button
        if AppDelegate.canReload && feedsTableView?.hasUncommittedUpdates == false {
            feedsTableView?.reloadData()
        }
        configureAllButton()
        configureSaveButton()
    }
}
