//
//  PinnableScrollView+scrollTo.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 16.11.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import UIKit

extension PinnableScrollView {
    /// Scroll to current element in the scroll view
    /// - Parameters:
    ///   - duration: scroll duration in seconds, 0.5 s by default
    ///   - completion: the block of code with bool parameter to call when scroll is completed, nil by default
    func scrollToCurrent(duration: TimeInterval = 0.5, completion: ((Bool) -> Void)? = nil) {
        scrollToElement(withIndex: currentIndex, duration: duration, completion: completion)
    }
    
    /// Scroll to element with the given ID
    /// - Parameters:
    ///   - id: the ID to search for and scroll to
    ///   - completion: the block of code with bool parameter to call when scroll is completed, nil by default
    func scrollToElement(withID id: String, completion: ((Bool) -> Void)? = nil) {
        // If element to scroll to not found, complete with success
        guard let index = index(of: id) else {
            debug("WARNING: Item with ID \(id) is not found")
            completion?(true)
            return
        }
        scrollToElement(withIndex: index, completion: completion)
    }

    /// Scroll to element with given index in the scroll view
    /// - Parameters:
    ///   - index: index of element to scroll to
    ///   - duration: scroll duration in seconds, 0.5 s by default
    ///   - completion: the block of code with bool parameter to call when scroll is completed, nil by default
    func scrollToElement(withIndex index: Int, duration: TimeInterval = 0.5, completion: ((Bool) -> Void)? = nil) {
        // Copy computed properties to local variables
        let count = count
        let elementWidth = elementWidth
        
        // If there are no views to scroll, complete with success status
        guard 0 < count else {
            completion?(true)
            return
        }
        let index = (index + count) % count
        
        // Don't scroll if already scrolling
        guard !isScrolling else {
            completion?(true)
            return
        }
        
        // Update stored properties
        isScrolling = true
        scrolledIndex = index
        
        UIView.animate(
            withDuration: duration,
            animations: {
                self.contentOffset.x = elementWidth * CGFloat(index)
            },
            completion: { finished in
                self.isScrolling = false
                completion?(finished)
            }
        )
    }
    
    /// Scroll to the last element in the scroll view
    /// - Parameters:
    ///   - duration: scroll duration in seconds, 0.5 s by default
    ///   - completion: the block of code with bool parameter to call when scroll is completed, nil by default
    func scrollToLast(duration: TimeInterval = 0.5, completion: ((Bool) -> Void)? = nil) {
        scrollToElement(withIndex: count - 1, duration: duration, completion: completion)
    }
    
    /// Scroll to random element in the scroll view
    /// - Parameter duration: scroll duration in seconds, 1 s by default
    func scrollToRandom(duration: TimeInterval = 1) {
        // Copy computed properties to local variables
        let count = count
        let currentIndex = currentIndex
        
        // Find random index not equal to current index
        var randomIndex = 0
        if 1 < count {
            repeat {
                randomIndex = .random(in: 0 ..< count)
            } while randomIndex == currentIndex
        }
        scrollToElement(withIndex: randomIndex, duration: duration)
    }
    
    /// Scroll to element most recently scrolled to in the scroll view
    /// - Parameters:
    ///   - duration: scroll duration in seconds, 0.5 s by default
    ///   - completion: the block of code with bool parameter to call when scroll is completed, nil by default
    func scrollToRecent(duration: TimeInterval = 0.5, completion: ((Bool) -> Void)? = nil) {
        scrollToElement(withIndex: scrolledIndex, duration: duration, completion: completion)
    }
}
