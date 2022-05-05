//
//  FeedsSourceViewController+Actions.swift
//  Outfit Selection
//
//  Created by Evgeniy Goncharov on 05.05.2022.
//  Copyright © 2022 Denis Bystruev. All rights reserved.
//

import UIKit

extension FeedsSourceViewController {
    // MARK: - Actions
    /// Call when leftBarButtonItem tapped
    @objc func cancelButtonTap() {
        // Hide backButton
        navigationItem.hidesBackButton = true
        debug("TODO: Restore selected feeds")

        // Return to called viewController
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Actions
    @IBAction func saveButtonTap() {
        debug("TODO: saveButtonTap ")
        // Back to profile viewController
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func selectAllButtonTapped(_ sender: SelectableButtonItem) {
        // Switch the selection
        sender.isButtonSelected.toggle()
        let isSelected = sender.isButtonSelected
        
        // Select / deselect all occasions save the selection to permanent storage
        for name in FeedsSource.all.names {
            guard let feed = FeedsSource.all.first(where: { $0.name == name }) else { return }
            FeedsSource.selectWithoutSaving(feed: feed, shouldUse: isSelected )
        }
        
        // Save selected occasions
        FeedsSource.saveSelectedFeeds()
        
        // Reload feeds and enable / disable go button
        feedsTableView.reloadData()
        configureSaveButton()
    }
}
