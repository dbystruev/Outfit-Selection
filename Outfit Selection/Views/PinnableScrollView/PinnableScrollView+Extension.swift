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
    
    /// Items of each of the arranged subviews of the pinnable scroll view
    var items: [Item] {
        stackView?.arrangedSubviews.compactMap { ($0 as? UIImageView)?.item } ?? []
    }
    
    /// Item IDs of each of the arranged subviews of the pinnable scroll view
    var itemIDs: [String] { items.IDs }
    
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
    
    /// Search for the first element with a given ID and return its index if found, or nil if not found
    /// - Parameter id: the ID to search for
    /// - Returns: the index of the first element with the given ID
    func index(of id: String) -> Int? {
        itemIDs.firstIndex(of: id)
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
        // If there are no views to scroll, complete with success status
        guard 0 < count else {
            completion?(true)
            return
        }
        let index = (index + count) % count
        
        UIView.animate(
            withDuration: duration,
            animations: { self.contentOffset.x = self.elementWidth * CGFloat(index) },
            completion: completion
        )
    }
    
    /// Scroll to element with the given ID
    /// - Parameters:
    ///   - id: the ID to search for and scroll to
    ///   - completion: the block of code to be executed when scrolling ends
    func scrollToElementIfPresent(with id: String, completion: ((Bool) -> Void)? = nil) {
        // If element to scroll to not found, complete with success
        guard let index = index(of: id) else {
            completion?(true)
            return
        }
        scrollToElement(withIndex: index, completion: completion)
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
    
    /// Set visibility of all elements in the scroll view's stack view
    /// - Parameters:
    ///   - subcategoryIDs: subcategory IDs of elements whose visibility is defined by visible parameter, all other elements are set to !visible
    ///   - visible: show if true, hide if false
    func setElements(with subcategoryIDs: [Int], visible: Bool) {
        // Make a set of subcategory IDs to make comparisons easier
        let subcategoryIDSet = Set(subcategoryIDs)
        
        // Go through all elements in the scroll view's stack view and show/hide them
        stackView?
            .arrangedSubviews
            .compactMap { $0 as? UIImageView }
            .forEach { imageView in
                // Get the list of item subcategory IDs
                guard let itemSubcategoryIDs = imageView.item?.subcategoryIDs else { return }
                
                // Compare occasion subcategories with item's
                if subcategoryIDSet.intersection(itemSubcategoryIDs).isEmpty {
                    // Hide (when visible is true) if there are no subcategories in common
                    imageView.isHidden = visible
                } else {
                    // Show (when visible is true) if there are subcategories in common
                    imageView.isHidden = !visible
                }
            }
    }
}
