//
//  BrandsViewController+UISearchBarDelegate.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 24.09.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import UIKit

extension BrandsViewController: UISearchBarDelegate {
    // MARK: - Helper Methods
    /// Defer collection view reload until enough time has passed
    /// - Parameters:
    ///   - searchBar: the search bar that is being edited
    ///   - interval: the time to postpone the reload fior
    func deferredReload(_ searchBar: UISearchBar, in interval: TimeInterval = 2) {
        if let lastClick = lastClick, interval < Date().timeIntervalSince(lastClick) {
            self.lastClick = nil
            brandsCollectionView.reloadData()
        } else {
            if searchBar.isFirstResponder {
                DispatchQueue.main.asyncAfter(deadline: .now() + interval) {
                    self.deferredReload(searchBar, in: interval)
                }
            }
        }
    }
    
    /// End search bar editing and reload brands collection view
    /// - Parameters:
    ///   - searchBar: the search bar that is being edited
    ///   - filter: the text to use for filter
    func finishEditing(_ searchBar: UISearchBar, filter: String? = nil) {
        brandedImages.filter = filter ?? ""
        brandsCollectionView.searchBar = nil
        brandsCollectionView.reloadData()
        searchBar.endEditing(true)
    }
    
    // MARK: - UISearchBarDelegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        brandedImages.filter = searchBar.text ?? ""
        if lastClick == nil {
            deferredReload(searchBar)
        }
        lastClick = Date()
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
}
