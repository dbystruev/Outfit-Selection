//
//  BrandsCollectionView.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 24.09.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import UIKit

class BrandsCollectionView: UICollectionView {
    /// Link to search bar
    weak var searchBar: UISearchBar?
    
    override func reloadData() {
        super.reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.searchBar?.becomeFirstResponder()
        }
    }
}
