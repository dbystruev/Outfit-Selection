//
//  UITabBarController+findViewController.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 01.03.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import UIKit

extension UITabBarController {
    /// Finds the topmost view controller in tab bar controller hierarchy of a given type
    /// - Parameter type: UIViewController child type to search for
    /// - Returns: the view controller if found, nil if not
    func findViewController<T: UIViewController>(ofType type: T.Type) -> T? {
        // First search needed controller among direct children of this tab bar controller
        if let controller = viewControllers?.reversed().first(where: { $0 is T }) as? T {
            return controller
        }
        
        // If not found, get navigation controllers from children (if any)
        guard let navigationControllers = viewControllers?.compactMap({ $0 as? UINavigationController }) else {
            return nil
        }
        
        // And search for needed controllr among those child navigation controllers
        for navigationController in navigationControllers {
            if let controller = navigationController.findViewController(ofType: type) {
                return controller
            }
        }
        
        // Nothing found
        return nil
    }
}
