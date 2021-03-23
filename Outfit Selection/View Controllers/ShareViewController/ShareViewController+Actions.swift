//
//  ShareViewController+Actions.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 23.03.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import UIKit

// MARK: - Actions
extension ShareViewController {
    /// Called when more cell is selected
    @objc func moreSelected(_ sender: UITableViewCell) {
        // Create a view for screenshot
        let shareView = ShareView.instanceFromNib()
        shareView.configureLayout(logoVisible: true)
        shareView.configureContent(with: outfitView.pictureImageViews.map { $0.image }, items: outfitView.items)
        
        // Share the image
        let activityController = UIActivityViewController(activityItems: [shareView.asImage], applicationActivities: nil)
        activityController.popoverPresentationController?.sourceView = sender.accessoryView
        present(activityController, animated: true)
    }
}
