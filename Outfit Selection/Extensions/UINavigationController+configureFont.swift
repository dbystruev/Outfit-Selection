//
//  UINavigationController+configureFont.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 25.03.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import UIKit

extension UINavigationController {
    /// Configure navigation controller's bar title font
    func configureFont() {
        let fontName = "NotoSans-Bold"
        guard let font =  UIFont(name: fontName, size: 17) else {
            debug("ERROR setting font \(fontName)")
            return
        }
        navigationBar.titleTextAttributes = [NSAttributedString.Key.font: font]
    }
}
