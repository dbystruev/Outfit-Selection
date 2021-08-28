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
        let cell: FeedCell = {
            // Try to dequeue feed brand or item cell
            let identifier = kind == .brands ? FeedBrandCell.identifier : FeedItemCell.identifier
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier)
            
            // Check which one of the two was dequeued
            if let brandCell = cell as? FeedBrandCell {
                brandCell.configureContent()
                return brandCell
                
            } else if let feedCell = cell as? FeedItemCell {
                feedCell.configureContent(for: kind, items: Item.all.filter { $0.branded(selectedBrandNames) })
                return feedCell
            }
            
            // If none — warn and create a new feed cell
            debug("Can't dequeue \(identifier) cell")
            return kind == .brands ? FeedBrandCell() : FeedItemCell()
        }()
        
        cell.delegate = self
        return cell
    }
}
