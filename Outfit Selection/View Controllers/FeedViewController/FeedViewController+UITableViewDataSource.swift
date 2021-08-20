//
//  FeedViewController+UITableViewDataSource.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 20.08.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import UIKit

extension FeedViewController: UITableViewDataSource {
    var feedCellTitles: [String] {["Favorite brands", "New items for you", "Sales"]}
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedCellTitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FeedCell.identifier) as? FeedCell else {
            debug("Can't dequeue \(FeedCell.identifier) cell")
            return FeedCell()
        }
        cell.titleLabel.text = feedCellTitles[indexPath.row]
        return cell
    }
}
