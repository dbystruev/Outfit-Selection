//
//  UIView+nib.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 01.11.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import UIKit

extension UIView {
    // MARK: - Class Properties
    /// The nib object containing this view
    class var nib: UINib { UINib(nibName: className, bundle: nil) }
}
