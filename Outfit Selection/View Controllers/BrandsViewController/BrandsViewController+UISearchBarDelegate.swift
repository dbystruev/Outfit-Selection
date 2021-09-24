//
//  BrandsViewController+UISearchBarDelegate.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 24.09.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import UIKit

extension BrandsViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        brandedImages.filter = searchBar.text ?? ""
        brandsCollectionView.reloadSections([0])
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        brandedImages.filter = searchBar.text ?? ""
        brandsCollectionView.reloadSections([0])
    }
}
