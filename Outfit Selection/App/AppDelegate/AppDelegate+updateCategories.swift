//
//  AppDelegate+updateCategories.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 23.09.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

extension AppDelegate {
    // MARK: - Methods
    /// Update the list of categories from the server
    func updateCategories() {
        NetworkManager.shared.getCategories { categories in
            // Make sure we don't update to the empty list of categories
            guard let categories = categories, !categories.isEmpty else { return }
            
            Category.all = categories
        }
    }
}
