//
//  ItemViewController+UITableViewDelegate.swift
//  Outfit Selection
//
//  Created by Evgeniy Goncharov on 08.04.2022.
//  Copyright © 2022 Denis Bystruev. All rights reserved.
//

import UIKit

extension ItemViewController: UITableViewDelegate {
    /// Perform an action when a user taps an item
    /// - Parameters:
    ///   - tableView: the tableView with items
    ///   - indexPath: item index path the user has tapped on
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Save DataSource
        saveDatasource()
        
        // Configure new item with image
        configure(with: searchItems?[indexPath.row], image: nil)

        // Hide table with items
        tableStackView.isHidden = true
        
        // Clear teext from searchBar
        searchBar.text = ""
        
        // Hide keyboard
        view.endEditing(true)
        
        // Deselect row after tap
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Show back bar button
        backBarButtonItem.isEnabled = true
        
        // Update UI
        updateUI()
    }
    
    /// An action when a user scroll items into tableView
    /// - Parameters:
    ///   - scrollView: the scrollView
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Hide keyboard
        view.endEditing(true)
    }
    
    /// Save text from searchBar and items from tableView
    func saveDatasource() {
        searchText = searchBar.text
        searchItemsSave = searchItems
    }
}
