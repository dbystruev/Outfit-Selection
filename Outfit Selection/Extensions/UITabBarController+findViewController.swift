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
        viewControllers?.reversed().first(where: { $0 is T }) as? T
    }
}
