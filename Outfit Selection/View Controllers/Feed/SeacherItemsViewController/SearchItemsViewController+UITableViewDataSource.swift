//
//  SearchItemsViewController+UITableViewDataSource.swift
//  Outfit Selection
//
//  Created by Evgeniy Goncharov on 31.05.2022.
//  Copyright © 2022 Denis Bystruev. All rights reserved.
//

import UIKit

extension SearchItemsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ItemViewControllerCell.className, for: indexPath)
        // Cast viewControllet to cell
        guard let itemCell = cell as? ItemViewControllerCell else {
            debug("ERROR: Can't cast \(cell) to \(ItemViewControllerCell.self)")
            return cell
        }
        
        // Check current searchItems
        guard let items = self.searchItems else { return cell }
    
        // Configure item cell
        itemCell.configureContent(with: items[indexPath.row])
        return itemCell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        searchItems?.count ?? 0
    }
}
