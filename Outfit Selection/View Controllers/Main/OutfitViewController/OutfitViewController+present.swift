//
//  OutfitViewController+present.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 31/07/2019.
//  Copyright © 2019–2020 Denis Bystruev. All rights reserved.
//

import UIKit

extension OutfitViewController {
    /// Instantiate and present brands view controller
    func presentBrandsViewController() {
        // Pop to Brands View Controller
        popToViewController(withType: BrandsViewController.self)
    }
    
    /// Find a view controller of a given type in navigation controller hierarchy and pop to it
    /// - Parameter type: type of a view controller to search for
    func popToViewController<T>(withType type: T.Type) {
        // Get the list all controllers under navigation controller
        guard let controllers = navigationController?.viewControllers else { return }
        
        // Find a view controller with the given type in the list of all controllers
        guard let controller = controllers.first(where: { $0 is T }) else { return }
        
        // Pop to the view controller of the given type
        navigationController?.popToViewController(controller, animated: true)
    }
}
