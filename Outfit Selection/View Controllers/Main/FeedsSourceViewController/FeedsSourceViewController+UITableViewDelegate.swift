//
//  FeedsSourceViewController+UITableViewDelegate.swift
//  Outfit Selection
//
//  Created by Evgeniy Goncharov on 05.05.2022.
//  Copyright © 2022 Denis Bystruev. All rights reserved.
//

import UIKit

extension FeedsSourceViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Toggle all feeds with the same title and reload the table
        let feed = FeedsSource.all[indexPath.row]
        
        /// Select feeds
        FeedsSource.select(feed: feed, shouldUse: !feed.shouldUse)
        
        tableView.reloadRows(at: [indexPath], with: .none)

        // Configure the button
        configureSaveButton()
    }
}
