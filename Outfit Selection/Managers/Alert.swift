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
    ///   - message: alert messages
    ///   - actionTitles: action titles
    ///   - styles: alert action styles
    ///   - handlers: actions to call when correspoinding actions are selected
    /// - Returns: configured  UI alert controller
    static func configured(
        _ title: String?,
        message: String? = nil,
        actionTitles: [String] = ["OK"~],
        styles: [UIAlertAction.Style] = [.default],
        handlers: [(UIAlertAction) -> Void] = []
    ) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        for index in 0 ..< actionTitles.count {
            // Create and add the action
            let action = UIAlertAction(
                title: actionTitles[index], style: styles[safe: index] ?? .default, handler: handlers[safe: index]
            )
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
        configured(
            "Dislike"~,
            message: "Do you really want to dislike the item?"~,
            actionTitles: ["Yes"~, "Cancel"~],
            styles: [.default, .cancel],
            handlers: [{ action in
                Items.dislike(item)
                handler?(action)
            }]
        )
    }
    
    static func genderChange(
        to newGender: Gender,
        sender: ProfileViewController
    ) -> UIAlertController {
        configured(
            "Change to"~ + " \(newGender.rawValue~)",
            message: "Will reload items and wishlists"~,
            actionTitles: ["Don't"~, "Change"~],
            styles: [.cancel, .destructive],
            handlers: [{ _ in
                // Keep gender to current
                sender.shownGender = Gender.current
                if AppDelegate.canReload && sender.profileCollectionView?.hasUncommittedUpdates == false {
                    sender.profileCollectionView.reloadSections([0])
                }
            }, { _ in
                // Reload gender section with new gender
                Gender.current = newGender
                guard let tabBarController = sender.tabBarController as? TabBarController else {
                    debug("ERROR: can't cast", sender.tabBarController, "to TabBarConroller")
                    return
                }
                tabBarController.reloadItems()
            }]
        )
    }
    
    /// Configure and return UI alert controller for add occasion to wishlist collection
    /// - Parameters:
    ///   - items: the items to will be added into wishlist
    ///   - occasion: current selected occasion
    ///   - navigationController : navigation controller for find like button
    /// - Returns: the configured UI alert controller
    static func occasionToCollection(
        items: Items,
        occasion: String,
        navigationController: UINavigationController
    ) -> UIAlertController {
        configured(
            "Save to wishlists?"~,
            message: occasion + " " + "is going to be saved to wishlist"~,
            actionTitles: ["Cancel"~, "OK"~],
            styles: [.cancel, .destructive],
            handlers: [{ _ in
            },{ _ in
                Wishlist.add(items, occasion: occasion)
                
                // Select like button at outfit view controller
                let tabBarController = navigationController.findViewController(ofType: UITabBarController.self)
                let navigationController = tabBarController?.selectedViewController as? UINavigationController
                let outfitController = navigationController?.viewControllers.first as? OutfitViewController
                outfitController?.likeButton.isSelected = true
            }]
        )
    }
    
    // MARK: - Static Computed Properties
    static var noItems: UIAlertController {
        configured(
            "Can't create collection",
            message: "Please add some items or outfits to the wishlists by liking them before creating a collection"
        )
    }
}
