//
//  LogoViewController+UINavigationControllerDelegate.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 31.01.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import UIKit

// MARK: - UINavigationControllerDelegate
extension LogoViewController: UINavigationControllerDelegate {
    ///  Returns a noninteractive animator object for use during view controller transitions
    /// - Parameters:
    ///   - navigationController: the navigation controller whose navigation stack is changing
    ///   - operation: the type of transition operation that is occurring — .push or .pop
    ///   - fromVC: the currently visible view controller
    ///   - toVC: the view controller that should be visible at the end of the transition
    /// - Returns: the animator object responsible for managing the transition animations, or nil for the standard navigation controller transitions
    func navigationController(_ navigationController: UINavigationController,
                              animationControllerFor operation: UINavigationController.Operation,
                              from fromVC: UIViewController,
                              to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition
    }
}
