//
//  UIViewController+touchesBegan.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 24.09.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import UIKit

extension UIViewController {
    /// Close keyboard when touches outside if began
    /// - Parameters:
    ///   - touches: the touches to pass to parent
    ///   - event: the event to pass to parent
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
}
