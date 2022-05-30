//
//  FeedItemViewController+Actions.swift
//  Outfit Selection
//
//  Created by Evgeniy Goncharov on 27.05.2022.
//  Copyright © 2022 Denis Bystruev. All rights reserved.
//

import UIKit

extension FeedItemViewController {
    // MARK: - Methods
    @objc func editButtonTapped(_ sender: Any) {
        // If not — jump to creating new collection
        performSegue(withIdentifier: CollectionNameViewController.segueIdentifier, sender: self)
    }
    
    @objc func saveButtonTapped(_ sender: Any) {
        // TODO: Save current collection into pickItems
    }
    
    @objc func cancelButtonTapped(_ sender: Any) {        
        setEditing(false, animated: true)
    }
    
    @objc func deleteButtonTapped(_ sender: Any) {
        guard let wishlistViewController = navigationController?.findViewController(ofType: WishlistViewController.self) else {
            debug("ERROR:", WishlistViewController.className, " not found in this navigation controller")
            return
        }
        
        guard let name = section.title else { return }
        // Save collections to user defaults on exit
        Collection.remove(name: name)
        
        // Remove collection from collections items
        wishlistViewController.feedController.removeSection(section: section)
        navigationController?.popViewController(animated: true)
    }
    
    /// Called when share button  was tapped
    @objc func shareButtonTapped(_ sender: Any) {
        // Identificator for universal share link
        let id: String = "in."
        let nameParam: String = "&name=eq."
        
        // Get current item IDs
        let itemIDs = "(\(items.IDs.commaJoined))"

        // Parts of the universal link
        let scheme = Global.UniversalLinks.scheme.https
        let domain = Global.UniversalLinks.domain.getoutfit
        let itemsParam = Global.UniversalLinks.path.items
        let nameUrlEncoded = name?.addingPercentEncoding(withAllowedCharacters: .alphanumerics)
        
        // Build share link
        let itemURLShare = URL(string: scheme + domain + itemsParam + id + itemIDs + nameParam + (nameUrlEncoded ?? ""))
        debug("INFO:", itemURLShare)
    
        // Share item url
        let activityController = UIActivityViewController(activityItems: [itemURLShare as Any], applicationActivities: nil)
        activityController.popoverPresentationController?.sourceView = (sender as AnyObject).customView
        present(activityController, animated: true)
    }
    
    // Alert for logout
    @objc func showAlert() {
        let alert = Alert.configured(
            "Delete the collection"~,
            message: "Are you sure you want to delete the collection?"~,
            actionTitles: ["Cancel"~, "Yes"~],
            styles: [.cancel, .destructive],
            handlers: [{ _ in
            },{ _ in
                self.deleteButtonTapped(self)
            }])
        present(alert, animated: true)
    }
}
