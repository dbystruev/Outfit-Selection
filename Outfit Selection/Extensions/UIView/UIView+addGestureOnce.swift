//
//  UIView+addGestureOnce.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 30.11.2020.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import UIKit

extension UIView {
    /// Initializes a view with given gesture recognizer object with a target and an action selector, once.
    /// - Parameters:
    ///   - gestureRecognizer: a gesture recognizer to use
    ///   - target: an object that is the recipient of action messages sent by the receiver when it recognizes a gesture. nil is not a valid value
    ///   - action: a selector that identifies the method implemented by the target to handle the gesture recognized by the receiver. nil is not a valid value
    ///   - delegate: gesture recognizer delegate to use with the gesture
    ///   - direction: direction for swipe gesture, nil by default
    func addGestureOnce<T: UIGestureRecognizer>(_: T.Type,
                                                target: Any?,
                                                action: Selector?,
                                                delegate: UIGestureRecognizerDelegate?,
                                                direction: UISwipeGestureRecognizer.Direction? = nil) {
        // Counter for the number of gestures of given type (and direction for swipe gesture)
        let gestureCount: Int
        
        // Create a gesture recognizer
        let gestureRecognizer = T(target: target, action: action)
        
        // Check if we have a swipe gesture recognier with a given direction
        if let direction = direction, let swipeGestireRecognizer = gestureRecognizer as? UISwipeGestureRecognizer {
            // Count swipe gesture recognizers with a given direction
            gestureCount = gestureRecognizers?
                .compactMap({ $0 as? UISwipeGestureRecognizer })
                .filter({ $0.direction == direction })
                .count ?? 0
            // Set the swipe gesture recognizer direction
            swipeGestireRecognizer.direction = direction
        } else {
            // Count gesture recognizers of a given type
            gestureCount = gestureRecognizers?.filter { $0 is T }.count ?? 0
        }
        
        guard gestureCount < 1 else {
//            debug("WARNING: Gesture count for \(T.self) on \(self) = \(gestureCount)")
            return
        }
        
        // Setup and add a gesture recognizer
        gestureRecognizer.delegate = delegate
        addGestureRecognizer(gestureRecognizer)
        
        // Enable user interaction
        isUserInteractionEnabled = true
    }
    
    /// Initializes a view with given pan gesture recognizer object with a target and an action selector, once.
    /// - Parameters:
    ///   - target: an object that is the recipient of action messages sent by the receiver when it recognizes a pan gesture. nil is not a valid value.
    ///   - action: a selector that identifies the method implemented by the target to handle the pan gesture recognized by the receiver. nil is not a valid value.
    ///   - delegate: gesture recognizer delegate to use with the gesture. nil by default.
    func addPanOnce(target: Any?, action: Selector?, delegate: UIGestureRecognizerDelegate? = nil) {
        addGestureOnce(UIPanGestureRecognizer.self, target: target, action: action, delegate: delegate)
    }
    
    /// Initializes a view with given swipe gesture recognizer object with a target and an action selector, once
    /// - Parameters:
    ///   - target: an object that is the recipient of action messages sent by the receiver when it recognizes a swipe gesture. nil is not a valid value.
    ///   - action: a selector that identifies the method implemented by the target to handle the swipe gesture recognized by the receiver. nil is not a valid value.
    ///   - delegate: gesture recognizer delegate to use with the gesture. nil by default.
    ///   - direction: swipe direction
    func addSwipeOnce(target: Any?,
                      action: Selector?,
                      delegate: UIGestureRecognizerDelegate? = nil,
                      direction: UISwipeGestureRecognizer.Direction) {
        addGestureOnce(UISwipeGestureRecognizer.self, target: target, action: action, delegate: delegate)
    }
    
    /// Initializes a view with given tap gesture recognizer object with a target and an action selector, once.
    /// - Parameters:
    ///   - target: an object that is the recipient of action messages sent by the receiver when it recognizes a tap gesture. nil is not a valid value.
    ///   - action: a selector that identifies the method implemented by the target to handle the tap gesture recognized by the receiver. nil is not a valid value.
    ///   - delegate: gesture recognizer delegate to use with the gesture. nil by default.
    func addTapOnce(target: Any?, action: Selector?, delegate: UIGestureRecognizerDelegate? = nil) {
        addGestureOnce(UITapGestureRecognizer.self, target: target, action: action, delegate: delegate)
    }
}
