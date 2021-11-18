//
//  PinnableScrollView+Methods.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 19/06/2019.
//  Copyright © 2019–2020 Denis Bystruev. All rights reserved.
//

import UIKit

// MARK: - Extension
extension PinnableScrollView {
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
    
    /// Clear the border around the scroll view
    public func clearBorder() {
        layer.borderWidth = 0
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
    
    /// Restore the border around the scroll view
    public func restoreBorder() {
        layer.borderColor = tintColor.cgColor
        layer.borderWidth = isPinned ? 1 : 0
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
        // Go through all elements in the scroll view's stack view and show/hide them
        stackView?
            .arrangedSubviews
            .compactMap { $0 as? UIImageView }
            .forEach { imageView in
                // Compare occasion subcategories with item's
                if imageView.item?.isMatching(subcategoryIDs) == true {
                    // Show (when visible is true) if there are subcategories in common
                    imageView.alpha = visible ? 1 : 0
                } else {
                    // Hide (when visible is true) if there are no subcategories in common
                    imageView.alpha = visible ? 0 : 1
                }
            }
    }
}
