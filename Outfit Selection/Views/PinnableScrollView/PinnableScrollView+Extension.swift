//
//  PinnableScrollView+Extension.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 19/06/2019.
//  Copyright © 2019–2020 Denis Bystruev. All rights reserved.
//

import UIKit

// MARK: - Extension
extension PinnableScrollView {
    // MARK: - Computed Properties
    var count: Int {
        stackView?.arrangedSubviews.count ?? 0
    }
    
    var itemCount: Int {
        stackView?.arrangedSubviews.reduce(0, { result, view in
            let result = result ?? 0
            guard let imageView = view as? UIImageView else { return result }
            guard imageView.image != nil && 0 <= imageView.tag else { return result }
            return result + 1
        }) ?? 0
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
        subviews.first as? UIStackView
    }
    
    // MARK: - Methods
    func clear() {
        unpin()
        if 1 < count {
            for _ in 1 ..< count {
                stackView?.arrangedSubviews.last?.removeFromSuperview()
            }
        }
        let imageView = stackView?.arrangedSubviews.first as? UIImageView
        imageView?.image = nil
        imageView?.tag = -1
    }
    
    func deleteImageView(withIndex deleteIndex: Int) {
        guard let imageView = getImageView(withIndex: deleteIndex) else { return }
        if deleteIndex == 0 {
            contentOffset.x = 0
            imageView.image = nil
            guard let secondImageView = getImageView(withIndex: 1) else { return }
            imageView.image = secondImageView.image
            imageView.tag = secondImageView.tag
            secondImageView.removeFromSuperview()
        } else {
            if deleteIndex < count - 1 {
                contentOffset.x -= elementWidth
            }
            imageView.removeFromSuperview()
        }
    }
    
    func getImageView(withIndex index: Int? = nil) -> UIImageView? {
        guard 0 < count else { return nil }
        let index = index ?? currentIndex
        guard 0 <= index && index < count else { return nil }
        return stackView?.arrangedSubviews[index] as? UIImageView
    }
    
    func insert(image: UIImage?, atIndex index: Int? = nil) -> UIImageView {
        if let lastImageView = stackView?.arrangedSubviews.last as? UIImageView {
            guard lastImageView.image != nil else {
                lastImageView.image = image
                return lastImageView
            }
        }
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        let index = index ?? count
        stackView?.insertArrangedSubview(imageView, at: index)
        return imageView
    }
    
    func insertAndScroll(image: UIImage?, atIndex index: Int? = nil, completion: ((Bool) -> Void)? = nil) -> UIImageView {
        let index = index ?? currentIndex + 1
        let imageView = insert(image: image, atIndex: index)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.scrollToElement(withIndex: index, duration: 1, completion: completion)
        }
        return imageView
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
    
    func scrollToCurrentElement(duration: TimeInterval = 0.5, completion: ((Bool) -> Void)? = nil) {
        scrollToElement(withIndex: currentIndex, duration: duration, completion: completion)
    }
    
    func scrollToElement(withIndex index: Int, duration: TimeInterval = 0.5, completion: ((Bool) -> Void)? = nil) {
        guard 0 < count else { return }
        let index = (index + count) % count
        UIView.animate(withDuration: duration, animations: {
            self.contentOffset.x = self.elementWidth * CGFloat(index)
        }, completion: completion)
    }
    
    func scrollToLastElement(duration: TimeInterval = 0.5, completion: ((Bool) -> Void)? = nil) {
        scrollToElement(withIndex: count - 1, duration: duration, completion: completion)
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
