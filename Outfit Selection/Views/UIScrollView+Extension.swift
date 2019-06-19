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
        return stackView?.arrangedSubviews.count ?? 0
    }
    
    var currentIndex: Int {
        guard 0 < elementWidth else { return 0 }
        return Int(round(contentOffset.x / elementWidth))
    }
    
    var elementWidth: CGFloat {
        guard 0 < count else { return 0 }
        return contentSize.width / CGFloat(count)
    }
    
    var stackView: UIStackView? {
        return subviews.first as? UIStackView
    }
    
    func add(image: UIImage?) {
        let imageView = UIImageView(image: image)
        stackView?.insertArrangedSubview(imageView, at: currentIndex + 1)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.scrollToElement(withIndex: self.currentIndex + 1, duration: 1)
        }
    }
    
    func scrollToRandomElement(duration: TimeInterval = 1) {
        var random: Int
        repeat {
            random = .random(in: 0 ..< count)
        } while random == currentIndex
        scrollToElement(withIndex: random, duration: duration)
    }
    
    func scrollToElement(withIndex index: Int? = nil, duration: TimeInterval = 0.5) {
        let index = (index ?? currentIndex) % count
        UIView.animate(withDuration: duration) {
            self.contentOffset.x = self.elementWidth * CGFloat(index)
        }
    }
    
    func setEditing(_ editing: Bool) {
        isUserInteractionEnabled = !editing
        if editing {
            mask = UIView(frame: bounds)
            mask?.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        } else {
            mask = nil
        }
    }
}
