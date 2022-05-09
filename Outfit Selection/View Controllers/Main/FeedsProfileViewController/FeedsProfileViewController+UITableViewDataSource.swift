//
//  FeedsSourceViewController+UITableViewDataSource.swift
//  Outfit Selection
//
//  Created by Evgeniy Goncharov on 05.05.2022.
//  Copyright © 2022 Denis Bystruev. All rights reserved.
//

import UIKit

extension FeedsProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedsProfileNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let feedsCell: FeedsProfileCell = {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: FeedsProfileCell.reuseId) as? FeedsProfileCell else {
                debug("WARNING: Can't dequeue a \(FeedsProfileCell.reuseId) cell from \(tableView)")
                return FeedsProfileCell()
            }
            return cell
        }()
        
        // Get feed for configure cell
        let name = feedsProfileNames[indexPath.row]
        guard let feed = FeedsProfile.all.first(where: { $0.name == name }) else {
            debug("WARNING: Can't fiind a \(name) into \(FeedsProfile.self)")
            return feedsCell
        }
        
        // Configure content cell
        feedsCell.configureContent(with: feed)
        return feedsCell
    }
}
