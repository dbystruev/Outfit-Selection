//
//  UIViewController+identifiers.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 09.09.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import UIKit

extension UIViewController {
    // MARK: - Static Properties
    /// Segue ID
    class var segueIdentifier: String {
        "\(storyboardId.decapitalizingFirstLetter)Segue"
    }
    
    /// Storyboard ID
    class var storyboardId: String { String(describing: Self.self) }
}
