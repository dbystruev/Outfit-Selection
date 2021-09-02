//
//  Alert.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 02.09.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import UIKit

enum Alert {
    // MARK: - Static Methods
    /// Configure and return UI alert controller
    /// - Parameters:
    ///   - title: alert title
    ///   - message: alert message
    ///   - handler: action to call when this action is selected
    /// - Returns: configured  UI alert controller
    static func configure(_ title: String?, message: String? = nil, handler: ((UIAlertAction) -> Void)? = nil) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        let yes = UIAlertAction(title: "Yes", style: .default, handler: handler)
        for action in [cancel, yes] {
            alert.addAction(action)
        }
        return alert
    }
    
    /// Configure and return UI alert controller for disliking the item
    /// - Parameters:
    ///   - item: the item to be disliked / removed
    ///   - handler: the handler to be called after user confirms the action and the item has been removed
    /// - Returns: the configured UI alert controller
    static func dislike(_ item: Item?, handler: ((UIAlertAction) -> Void)? = nil) -> UIAlertController {
        return configure("Dislike", message: "Do you really want to dislike the item?") { action in
            Item.dislike(item)
            handler?(action)
        }
    }
}
