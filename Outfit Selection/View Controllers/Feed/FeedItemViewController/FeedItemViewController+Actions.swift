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
    @objc func addButtonTapped(_ sender: Any) {
        // TODO: Save current collection into pickItems
        debug("addButtonTapped tapped")
    }
    
    @objc func editButtonTapped(_ sender: Any) {
        // If not — jump to creating new collection
        performSegue(withIdentifier: CollectionNameViewController.segueIdentifier, sender: self)
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
}
