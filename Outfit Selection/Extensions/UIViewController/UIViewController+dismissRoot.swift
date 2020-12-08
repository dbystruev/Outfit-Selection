//
//  UIViewController+dismissRoot.swift
//  Tadam
//
//  Created by Denis Bystruev on 04.09.2020.
//
import UIKit

extension UIViewController {
    /// Dismisses the top view controller that  presented this and parent view controllers
    /// - Parameter flag: pass true to animate the transition
    func dismissRoot(animated flag: Bool) {
        var child: UIViewController? = self
        var parent = presentingViewController
        while parent != nil {
            child = parent
            parent = child?.presentingViewController
        }
        child?.dismiss(animated: flag)
    }
}
