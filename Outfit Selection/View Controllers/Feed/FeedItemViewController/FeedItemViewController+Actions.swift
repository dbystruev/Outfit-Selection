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
    /// Called when share button  was tapped
    @objc func shareButtonTapped(_ sender: Any) {
        debug("INFO: Share Button Tapped")
    
        // Identificator for universal share link
        let id: String = "in."
        let nameParam: String = "&name=eq."
        
        // Get current item IDs
        let itemIDs = "(\(items.IDs.commaJoined))" // TODO: Create tooples

        // Parts of the universal link
        let scheme = Global.UniversalLinks.scheme.https
        let domain = Global.UniversalLinks.domain.getoutfit
        let itemsParam = Global.UniversalLinks.path.items
        let nameUrlEncoded = name?.addingPercentEncoding(withAllowedCharacters: .alphanumerics)
        
        // Build share link
        let itemURLShare = URL(string: scheme + domain + itemsParam + id + itemIDs + nameParam + (nameUrlEncoded ?? ""))
    
        // Share item url
        let activityController = UIActivityViewController(activityItems: [itemURLShare as Any], applicationActivities: nil)
        activityController.popoverPresentationController?.sourceView = (sender as AnyObject).customView
        present(activityController, animated: true)
    }
}
