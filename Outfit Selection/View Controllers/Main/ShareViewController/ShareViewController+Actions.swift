//
//  ShareViewController+Actions.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 23.03.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import Photos
import UIKit

// MARK: - Actions
extension ShareViewController {
    /// Called when finished saving image to saved photo album
    /// - Parameters:
    ///   - image: image saved to photo album
    ///   - error: is there any error
    ///   - contextInfo: context info not used
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            debug("ERROR saving image to photo album: \(error.localizedDescription)")
            return
        }
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        let fetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        guard let lastAsset = fetchResult.firstObject else { return }
        guard let url = URL(string: "instagram://library?LocalIdentifier=\(lastAsset.localIdentifier)") else { return }
        guard UIApplication.shared.canOpenURL(url) else { return }
        UIApplication.shared.open(url)
    }
    
    /// Called when a link cell is selected
    /// - Parameter sender: the cell which was selected by the user
    ///   - type: type of the image to share
    func shareCopyLink(for type: ShareView.ShareType, _ sender: UITableViewCell) {
        // Get current items from layout
        let items = outfitView.items
        let itemIDs = items.compactMap { $0.id }
        
        // Chech items
        guard !itemIDs.isEmpty else { return }
        
        // Parts of the universal link
        let scheme = Global.UniversalLinks.scheme.https
        let subdomain = Global.UniversalLinks.subdomain.www
        let domain = Global.UniversalLinks.domain.getoutfit
        let patch = Global.UniversalLinks.path.items
        
        // Convert array items to string
        var itemsCommaJoined = itemIDs.commaJoined
        
        // Identificator for universal share link
        var id: String
        
        // Check and
        if itemIDs.count > 1 {
            id = "in."
            itemsCommaJoined = "(\(itemsCommaJoined))"
        } else {
            id = "eq."
        }
        
        // Build share link
        let shareLink = URL(string: scheme + subdomain + domain + patch + id + itemsCommaJoined)

        debug(shareLink)
        
        // Share the link
        let activityController = UIActivityViewController(activityItems: [shareLink as Any], applicationActivities: nil)
        activityController.popoverPresentationController?.sourceView = sender.accessoryView
        present(activityController, animated: true)
        navigationController?.popViewController(animated: true)
    }
    
    /// Called when more cell is selected
    /// - Parameters:
    ///   - type: type of the image to share
    ///   - sender: the cell which was selected by the user
    func shareImage(for type: ShareView.ShareType, _ sender: UITableViewCell) {
        // Create an image from a copy of outfit view
        let shareImage = outfitView.layout(for: type).asImage
        
        // Share the image
        let activityController = UIActivityViewController(activityItems: [shareImage], applicationActivities: nil)
        activityController.popoverPresentationController?.sourceView = sender.accessoryView
        present(activityController, animated: true)
        navigationController?.popViewController(animated: true)
    }
    
    /// Called when share to instragram cell is selected
    /// - Parameter sender: the cell which was selected by the user
    /// https://stackoverflow.com/a/38550562/7851379
    func shareToInstagramPost(_ sender: UITableViewCell) {
        let image = outfitView.layout(for: .instagramPost).asImage
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        navigationController?.popViewController(animated: true)
    }
    
    /// Called when share to instagram stories cell is selected
    /// - Parameter sender: the cell which was selected by the user
    /// https://betterprogramming.pub/how-to-share-a-photo-on-instagram-stories-in-swift-75319a669596
    /// https://www.8mincode.com/posts/how-to-share-an-image-on-instagram-with-ios-swift
    func shareToInstagramStories(_ sender: UITableViewCell) {
        defer {
            navigationController?.popViewController(animated: true)
        }
        
        guard let scheme = URL(string: "instagram-stories://share") else { return }
        guard UIApplication.shared.canOpenURL(scheme) else { return }
        guard let imageData = outfitView.layout(for: .instagramStories).asImage.pngData() else { return }
        
        let items = [["com.instagram.sharedSticker.backgroundImage": imageData]]
        let pasteboardOptions = [UIPasteboard.OptionsKey.expirationDate: Date().addingTimeInterval(60 * 5)]
        UIPasteboard.general.setItems(items, options: pasteboardOptions)
        UIApplication.shared.open(scheme)
    }
}
