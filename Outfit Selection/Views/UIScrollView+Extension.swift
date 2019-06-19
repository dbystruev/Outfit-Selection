//
//  UIScrollView+Extension.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 19/06/2019.
//  Copyright © 2019 Denis Bystruev. All rights reserved.
//

import UIKit

// MARK: - Extension
extension UIScrollView {
    var count: Int {
        guard let stackView = subviews.first as? UIStackView else { return 0 }
        return stackView.arrangedSubviews.count
    }
    
    var currentIndex: Int {
        guard 0 < elementWidth else { return 0 }
        return Int(round(contentOffset.x / elementWidth))
    }
    
    var elementWidth: CGFloat {
        guard 0 < count else { return 0 }
        return contentSize.width / CGFloat(count)
    }
    
    func snapToElement(withIndex index: Int? = nil) {
        let index = index ?? currentIndex
        UIView.animate(withDuration: 0.5) {
            self.contentOffset.x = self.elementWidth * CGFloat(index)
        }
    }
}
