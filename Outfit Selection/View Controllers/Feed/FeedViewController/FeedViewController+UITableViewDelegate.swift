//
//  FeedViewController+UITableViewDelegate.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 20.08.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import UIKit

extension FeedViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // Choose which kind the cell will have
        let kind = FeedItemCell.Kind.allCases[indexPath.row]
        
        return kind == .brands ? FeedBrandCell.height : FeedItemCell.height
    }
}
