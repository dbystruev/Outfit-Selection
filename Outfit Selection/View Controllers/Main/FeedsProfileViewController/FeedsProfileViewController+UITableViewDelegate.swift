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
        
        // Select feeds
        FeedsProfile.select(feed: feed, shouldUse: !feed.shouldUse)
        
        // Reload changed row
        tableView.reloadRows(at: [indexPath], with: .none)
        
        // TODO: Add guard and configure checkBox
        //tableView.cellForRow(at: indexPath) as? FeedsProfileCell

        // Configure the buttons
        configureAllButton()
        configureSaveButton()
    }
}
