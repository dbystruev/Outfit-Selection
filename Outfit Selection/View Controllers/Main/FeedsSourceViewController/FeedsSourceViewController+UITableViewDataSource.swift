//
//  FeedsSourceViewController+UITableViewDataSource.swift
//  Outfit Selection
//
//  Created by Evgeniy Goncharov on 05.05.2022.
//  Copyright © 2022 Denis Bystruev. All rights reserved.
//

import UIKit

extension FeedsSourceViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedsSourceNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let feedsCell: FeedsSourceCell = {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: FeedsSourceCell.reuseId) as? FeedsSourceCell else {
                debug("WARNING: Can't dequeue a \(FeedsSourceCell.reuseId) cell from \(tableView)")
                return FeedsSourceCell()
            }
            return cell
        }()
        
        // Get feed for configure cell
        let name = feedsSourceNames[indexPath.row]
        guard let feed = FeedsSource.all.first(where: { $0.name == name }) else {
            debug("WARNING: Can't fiind a \(name) into \(FeedsSource.self)")
            return feedsCell
        }
        
        // Configure content cell
        feedsCell.configureContent(with: feed)
        return feedsCell
    }
}
