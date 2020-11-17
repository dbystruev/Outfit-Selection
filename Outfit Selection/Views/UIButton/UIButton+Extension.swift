//
//  UIButton+Extension.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 20/06/2019.
//  Copyright © 2019 Denis Bystruev. All rights reserved.
//

import UIKit

// MARK: - Extension
extension UIButton {
    func setEditing(action: UIBarButtonItem.SystemItem) {
        switch action {
        case .add:
            isHidden = false
            isHighlighted = true
            isSelected = false
        case .trash:
            isHidden = false
            isHighlighted = false
            isSelected = true
        default:
            isHidden = true
            isHighlighted = false
            isSelected = false
        }
    }
}
