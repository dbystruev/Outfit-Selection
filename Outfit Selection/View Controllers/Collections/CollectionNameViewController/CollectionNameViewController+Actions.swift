//
//  CollectionNameViewController+Actions.swift
//  Outfit Selection
//
//  Created by Evgeniy Goncharov on 31.05.2022.
//  Copyright © 2022 Denis Bystruev. All rights reserved.
//

import UIKit

extension CollectionNameViewController {
    // MARK: - Actions
    @IBAction func addItemsButtonTapped(_ sender: UIButton) {
        nameTextField.endEditing(true)
        
        // Check that we have non-empty name
        guard let collectionName = nameTextField.text, !collectionName.isEmpty else {
            debug("WARNING: Collection name is empty")
            dismiss(animated: true)
            return
        }
        
        // Save collection name entered by the user
        self.collectionName = collectionName
        
        // Present collection select view controller
        dismiss(animated: true) {
            self.wishlistViewController?.performSegue(
                withIdentifier: CollectionSelectViewController.segueIdentifier,
                sender: self
            )
        }
    }
    
    @IBAction func collectionNameEditingChanged(_ sender: UITextField) {
        updateUI()
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
        showAlert()
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let feedItemViewController = feedItemViewController else {
            debug("ERROR:", FeedItemViewController.className, "not found in this navigation controller")
            return
        }
        
        guard let wishlistViewController = feedItemViewController.navigationController?.findViewController(ofType: WishlistViewController.self) else {
            debug("ERROR:", WishlistViewController.className, "not found in this navigation controller")
            return
        }
        
        // Set title for collection into presented view controller
        feedItemViewController.titleLabel.text = nameTextField.text
        
        // Get index section
        let index = feedItemViewController.indexSection
        
        // Make new PickType item
        let newPickType = PickType.collections(nameTextField.text ?? "")
        
        // Remove items and section
        let old = wishlistViewController.feedController.items[index]
        wishlistViewController.feedController.items.removeValue(forKey: old.key)
        
        // Append changed section with items
        wishlistViewController.feedController.addSection(items: old.value, to: newPickType)
        
        // Update collection from User Dafault
        Collection.update(oldName: feedItemViewController.name ?? "", newName: nameTextField.text ?? "" )
        dismiss(animated: true)
    }
    
    // MARK: - Private Methods
    /// Delete collection from wishlist
    private func deleteCollection() {
        guard let feedItemViewController = feedItemViewController else {
            debug("ERROR:", FeedItemViewController.className, " not found in this navigation controller")
            return
        }
        
        guard let name = feedItemViewController.section.title else { return }
        
        // Remove collection from user defaults
        Collection.remove(name: name)
        
        guard let wishlistViewController = feedItemViewController.navigationController?.findViewController(ofType: WishlistViewController.self) else {
            debug("ERROR:", WishlistViewController.className, " not found in this navigation controller")
            return
        }
        
        // Remove collection from collections items
        wishlistViewController.feedController.removeSection(section: feedItemViewController.section)
        // Retern to wishlistViewController
        feedItemViewController.navigationController?.popToViewController(wishlistViewController, animated: true)
        dismiss(animated: true)
    }
    
    // Alert for logout
    private func showAlert() {
        let alert = Alert.configured(
            "Delete the collection"~,
            message: "Are you sure you want to delete the collection?"~,
            actionTitles: ["Cancel"~, "Yes"~],
            styles: [.cancel, .destructive],
            handlers: [{ _ in
            },{ _ in
                self.deleteCollection()
            }])
        present(alert, animated: true)
    }
    
}
