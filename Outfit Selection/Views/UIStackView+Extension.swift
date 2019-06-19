//
//  UIStackView+Extension.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 20/06/2019.
//  Copyright © 2019 Denis Bystruev. All rights reserved.
//

import UIKit

extension UIStackView {
    func setEditing(_ editing: Bool) {
        arrangedSubviews.forEach { subview in
            if let stackView = subview as? UIStackView {
                stackView.setEditing(editing)
            } else if let scrollView = subview as? UIScrollView {
                scrollView.setEditing(editing)
            }
        }
    }
}
