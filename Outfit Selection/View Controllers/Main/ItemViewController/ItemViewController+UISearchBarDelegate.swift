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
    /// End search bar editing and reload brands collection view
    /// - Parameters:
    ///   - searchBar: the search bar that is being edited
    ///   - filter: the text to use for filter
    func finishEditing(_ searchBar: UISearchBar, filter: String? = nil) {
        searchBar.endEditing(true)
    }
    
    // MARK: - UISearchBarDelegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        tableStackView.isHidden = searchText.count > 3 ? false : true
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
        debug("")
    }
}
