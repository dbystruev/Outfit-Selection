//
//  UIViewController+tabBar.swift
//  Tadam
//
//  Created by Denis Bystruev on 12.11.2020.
//

import UIKit

extension UIViewController {
    /// Hides the tab bar
    /// - Returns: whether tab bar was hidden before
    @discardableResult func hideTabBar() -> Bool? {
        setTabBar(hidden: true)
    }
    
    /// Hides or unhides the tab bar
    /// - Parameter hide: if true hides the tab bar, if false shows the tab bar, if nil does not touch it
    /// - Returns: whether tab bar was hidden before
    @discardableResult func setTabBar(hidden: Bool?) -> Bool? {
        guard let tabBar = tabBarController?.tabBar else { return nil }
        let isHidden = tabBar.isHidden
        if let hidden = hidden {
            tabBar.isHidden = hidden
        }
        return isHidden
    }
    
    /// Unhides the tab bar
    /// - Returns: whether tab bar was hidden before
    @discardableResult func showTabBar() -> Bool? {
        setTabBar(hidden: false)
    }
}
