//
//  UINavigationController+findViewController.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 26.02.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import UIKit

extension UINavigationController {
    /// Finds the topmost view controller in navigation controller hierarchy of a given type
    /// - Parameter type: UIViewController child type to search for
    /// - Returns: the view controller if found, nil if not
    func findViewController<T: UIViewController>(ofType type: T.Type) -> T? {
        var navigationController: UINavigationController? = self
        
        while navigationController != nil {
            if let controller = navigationController?.viewControllers.reversed().first(where: { $0 is T }) as? T {
                return controller
            }
            navigationController = navigationController?.navigationController
        }
        
        return nil
    }
}
