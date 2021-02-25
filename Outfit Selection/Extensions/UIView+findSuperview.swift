//
//  UIView+findSuperview.swift
//  Tadam
//
//  Created by Denis Bystruev on 12.02.2021.
//
import UIKit

extension UIView {
    /// Find the first superview of given type
    /// - Parameter type: the type to search superview for
    /// - Returns: the found superview of given type or nil
    func findSuperview<T: UIView>(ofType type: T.Type) -> T? {
        var foundView = superview
        while foundView != nil {
            if let foundViewAsT = foundView as? T {
                return foundViewAsT
            }
            foundView = foundView?.superview
        }
        return nil
    }
}
