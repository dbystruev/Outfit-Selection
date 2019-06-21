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
    
    func deleteImage(withIndex deleteIndex: Int) {
        guard 1 < count else { return }
        guard 0 <= deleteIndex && deleteIndex < count else { return }
        guard let imageView = stackView?.arrangedSubviews[deleteIndex] as? UIImageView else { return }
        if deleteIndex == 0 {
            contentOffset.x = 0
            guard let secondImageView = stackView?.arrangedSubviews[1] as? UIImageView else { return }
            imageView.image = secondImageView.image
            stackView?.removeArrangedSubview(secondImageView)
            secondImageView.removeFromSuperview()
        } else {
            if deleteIndex < count - 1 {
                contentOffset.x -= elementWidth
            }
            stackView?.removeArrangedSubview(imageView)
            imageView.removeFromSuperview()
        }
    }
    
    func insert(image: UIImage?, atIndex index: Int? = nil) {
        if let lastImageView = stackView?.arrangedSubviews.last as? UIImageView {
            guard lastImageView.image != nil else {
                lastImageView.image = image
                return
            }
        }
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        let index = index ?? count
        stackView?.insertArrangedSubview(imageView, at: index)
    }
    
    func insertAndScroll(image: UIImage?, atIndex index: Int? = nil) {
        let index = index ?? currentIndex + 1
        insert(image: image, atIndex: index)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.scrollToElement(withIndex: index, duration: 1)
        }
    }
    
    func scrollToRandomElement(duration: TimeInterval = 1) {
        var random = 0
        if 1 < count {
            repeat {
                random = .random(in: 0 ..< count)
            } while random == currentIndex
        }
        scrollToElement(withIndex: random, duration: duration)
    }
    
    func scrollToElement(withIndex index: Int? = nil, duration: TimeInterval = 0.5, completion: ((Bool) -> Void)? = nil) {
        let index = (index ?? currentIndex) % count
        UIView.animate(withDuration: duration, animations: {
            self.contentOffset.x = self.elementWidth * CGFloat(index)
        }, completion: completion)
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
