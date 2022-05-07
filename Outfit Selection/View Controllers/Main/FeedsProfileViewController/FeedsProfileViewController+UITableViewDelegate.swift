//
//  FeedsProfileViewController+UITableViewDelegate.swift
//  Outfit Selection
//
//  Created by Evgeniy Goncharov on 05.05.2022.
//  Copyright © 2022 Denis Bystruev. All rights reserved.
//

import UIKit

extension FeedsProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Toggle all feeds with the same title and reload the table
        let feed = FeedsProfile.all[indexPath.row]
        
        // Select feedProfile
        FeedsProfile.select(feed: feed, shouldUse: !feed.shouldUse)
        
        guard let feedsProfileCell = tableView.cellForRow(at: indexPath) as? FeedsProfileCell else {
            debug("ERROR: Can't cast tableView cell as", FeedsProfileCell.className)
            return
        }
        
        // Configure CheckBox and set isHighlighted
        feedsProfileCell.configureCheckBox(isHighlighted: feed.shouldUse)

        // Configure the buttons
        configureAllButton()
        configureSaveButton()
    }
}
