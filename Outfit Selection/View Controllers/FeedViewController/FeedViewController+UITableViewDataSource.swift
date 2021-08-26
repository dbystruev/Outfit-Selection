//
//  FeedViewController+UITableViewDataSource.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 20.08.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import UIKit

extension FeedViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FeedItemCell.Kind.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Choose which kind the cell will have
        let kind = FeedItemCell.Kind.allCases[indexPath.row]
        
        // Obtain a feed cell
        let cell: FeedItemCell = {
            let identifier = kind == .brands ? FeedBrandCell.identifier : FeedItemCell.identifier
            guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? FeedItemCell else {
                debug("Can't dequeue \(identifier) cell")
                return kind == .brands ? FeedBrandCell() : FeedItemCell()
            }
            return cell
        }()
        
        // Configure the feed cell and return it
        cell.configureContent(for: kind, items: Item.all)
        return cell
    }
}
