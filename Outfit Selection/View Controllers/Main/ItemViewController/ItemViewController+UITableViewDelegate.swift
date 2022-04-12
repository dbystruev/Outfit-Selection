//
//  ItemViewController+UITableViewDelegate.swift
//  Outfit Selection
//
//  Created by Evgeniy Goncharov on 08.04.2022.
//  Copyright © 2022 Denis Bystruev. All rights reserved.
//

import UIKit

extension ItemViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Configure new item with image
        configure(with: items?[indexPath.row])
        // Hide table with items
        tableStackView.isHidden = true
        // Clear teext from searchBar
        searchBar.text = ""
        // Update UI
        updateUI()
    }
}
