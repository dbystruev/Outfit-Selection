//
//  ItemViewController+UISearchBarDelegate.swift
//  Outfit Selection
//
//  Created by Evgeniy Goncharov on 08.04.2022.
//  Copyright © 2022 Denis Bystruev. All rights reserved.
//

import UIKit

extension ItemViewController: UISearchBarDelegate {
    // MARK: - Helper Methods
    /// Defer tablev view reload until enough time has passed
    /// - Parameters:
    ///   - searchBar: the search bar that is being edited
    ///   - interval: the time to postpone the reload fior
    func deferredDownloadItems(_ searchBar: UISearchBar, in interval: TimeInterval = ItemViewController.searchKeystrokeDelay, searchText: String) {
        if let lastClick = lastClick, interval < Date().timeIntervalSince(lastClick) {
            self.lastClick = nil
            NetworkManager.shared.getItems(in: firstItem?.subcategoryIDs ?? [], for: Gender.current,  limited: limited, named: searchText) { items in
                guard let items = items else { return }
                self.searchItems = items
                
                DispatchQueue.main.async {
                    guard !items.isEmpty else {
                        /// Hide searchBar
                        self.tableStackView.isHidden = true
                        return
                    }
                    /// Show searchBar
                    self.tableStackView.isHidden = false
                    self.searchTableView.reloadData()
                }
            }
        } else {
            if searchBar.isFirstResponder {
                DispatchQueue.main.asyncAfter(deadline: .now() + interval) {
                    self.deferredDownloadItems(searchBar, in: interval, searchText: searchText)
                }
            }
        }
    }
    
    /// End search bar editing and reload  table view view
    /// - Parameters:
    ///   - searchBar: the search bar that is being edited
    ///   - filter: the text to use for filter
    private func finishEditing(_ searchBar: UISearchBar, filter: String? = nil) {
        searchBar.endEditing(true)
    }
    
    // MARK: - UISearchBarDelegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard searchText.count > 0 else {
            self.tableStackView.isHidden = true
            return
        }
        
        if lastClick == nil {
            deferredDownloadItems(searchBar, searchText: searchText)
        }
        // Start time
        lastClick = Date()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        searchBar.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        finishEditing(searchBar)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        finishEditing(searchBar, filter: searchBar.text)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        finishEditing(searchBar, filter: searchBar.text)
    }
    
    func searchBarResultsListButtonClicked(_ searchBar: UISearchBar) {
        finishEditing(searchBar)
    }
}
