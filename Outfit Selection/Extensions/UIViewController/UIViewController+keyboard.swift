//
//  UIViewController+keyboard.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 06.09.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//
//  https://spin.atomicobject.com/2020/03/23/uiscrollview-content-layout-guides/
//  3. Move Content under the Keyboard into View
//
//  See also https://developer.apple.com/library/archive/documentation/StringsTextFonts/Conceptual/TextAndWebiPhoneOS/KeyboardManagement/KeyboardManagement.html
import UIKit

extension UIViewController {
    // MARK: - Properties to be overriden in subsclasses
    /// An object which should be changed when keyboard appear / disappear, e. g. NSLayoutConstraint or UIScrollView
    @objc var keyboardObject: Any? { nil }
    
    /// The text field where keyboard appears
    @objc var keyboardTextField: UITextField? { nil }
    
    // MARK: - Actions
    /// Move the views up when keyboard appears
    @objc func keyboardDidShow(notification: Notification) {
        let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        guard let textField = keyboardTextField, let keyboardHeight = keyboardSize?.height else { return }
        
        if let constraint = keyboardObject as? NSLayoutConstraint {
            constraint.constant = keyboardHeight
        } else if let scrollView = keyboardObject as? UIScrollView {
            let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
            scrollView.contentInset = contentInsets
            scrollView.scrollIndicatorInsets = contentInsets
            let visibleRect = textField.convert(textField.bounds, to: scrollView)
            scrollView.scrollRectToVisible(visibleRect, animated: true)
        }
    }
    
    /// Move the views down when keyboard dissapears
    @objc func keyboardWillBeHidden(notification: Notification) {
        let contentInsets = UIEdgeInsets.zero
        
        if let constraint = keyboardObject as? NSLayoutConstraint {
            constraint.constant = 0
        } else if let scrollView = keyboardObject as? UIScrollView {
            scrollView.contentInset = contentInsets
            scrollView.scrollIndicatorInsets = contentInsets
        }
    }
    
    /// Called when the keyboard is about to be shown
    /// - Parameter notification: keyboard will show notification
    @objc func keyboardWillShow(notification: Notification) {
        // Does nothing, to be overwritten by children if needed
    }
    
    // MARK: - Methods
    /// Register for keyboard notifications
    /// - Parameters:
    ///   - textField: text field which is currently active
    ///   - object: a scroll view or constraint which should be updated when keyboard is hidden/shown
    func registerForKeyboardNotifications() {
        let selectors = [#selector(keyboardDidShow), #selector(keyboardWillBeHidden), #selector(keyboardWillShow)]
        let names = [UIResponder.keyboardDidShowNotification, UIResponder.keyboardWillHideNotification, UIResponder.keyboardWillShowNotification]
        
        // Subscribe to keyboard did show / will be hidden events
        for (selector, name) in zip(selectors, names) {
            NotificationCenter.default.addObserver(self, selector: selector, name: name, object: nil)
        }
    }
    
    /// Unregister from notifications
    func unregisterFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
}
