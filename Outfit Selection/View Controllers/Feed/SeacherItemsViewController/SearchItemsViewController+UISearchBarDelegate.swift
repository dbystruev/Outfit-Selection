//
//  SearchItemsViewController+UISearchBarDelegate.swift
//  Outfit Selection
//
//  Created by Evgeniy Goncharov on 31.05.2022.
//  Copyright © 2022 Denis Bystruev. All rights reserved.
//

import UIKit

extension SearchItemsViewController: UISearchBarDelegate {
    // MARK: - Helper Methods
    /// Defer tablev view reload until enough time has passed
    /// - Parameters:
    ///   - searchBar: the search bar that is being edited
    ///   - interval: the time to postpone the reload fior
    ///   - searchText: text for search
    func deferredDownloadItems(_ searchBar: UISearchBar, in interval: TimeInterval = ItemViewController.searchKeystrokeDelay, searchText: String) {
        if let lastClick = lastClick, interval < Date().timeIntervalSince(lastClick) {
            self.lastClick = nil
            NetworkManager.shared.getItems(for: Gender.current, limited: limited, named: searchText) { items in
                guard let items = items else { return }
                self.searchItems = items
                
                DispatchQueue.main.async {
                    guard !items.isEmpty else {
                        self.searchItems?.removeAll()
                        self.searchTableView?.reloadData()
                        return
                    }

                    if AppDelegate.canReload && self.searchTableView?.hasUncommittedUpdates == false {
                        self.searchTableView?.reloadData()
                    }
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

