//
//  ViewController+UI.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 19/06/2019.
//  Copyright © 2019–2020 Denis Bystruev. All rights reserved.
//

import UIKit

// MARK: - UI
extension OutfitViewController {
    func configureGenderItem() {
        switch gender {
        case .female:
            genderItem.image = UIImage(named: "female_icon")
        case .male:
            genderItem.image = UIImage(named: "male_icon")
        default:
            genderItem.image = nil
        }
    }
    
    func getScreenshot(of view: UIView) -> UIImage? {
        // Setup logo image view
        let logoImage = UIImage(named: "logo")
        let logoImageView = UIImageView(image: logoImage)
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.frame.origin.y += 16
        logoImageView.frame.size.width = view.frame.size.width
        
        // Add the logo image view to the view
        view.addSubview(logoImageView)
        
        // Get the renderer
        let renderer = UIGraphicsImageRenderer(size: view.bounds.size)
        let image = renderer.image { context in
            // Draw the screenshot view
            view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        }
        
        // Remove the logo image view from the view
        logoImageView.removeFromSuperview()
        
        return image
    }
    
    /// Load images for some items in Item.all filtered by category in Category.all.count into scroll views
    func loadImages() {
        // Clear scroll views
        scrollViews.clear()
        
        // Load images from view models into scroll view
        ItemManager.shared.loadImages(into: scrollViews)
        
        // Update the number of images loaded
        updateItemCount()
    }
    
    func pin() {
        scrollViews.pin()
        diceButtonItem.isEnabled = false
    }
    
    func setupToolbar() {
        // Bottom left button with price
        let priceTitle = OutfitViewController.loadingMessage
        priceButtonItem = UIBarButtonItem(title: priceTitle, style: .done, target: self, action: #selector(priceButtonTapped(_:)))
        
        // Bottom middle button with dice
        let diceImage = UIImage(named: "dice")
        diceButtonItem = UIBarButtonItem(image: diceImage, style: .plain, target: self, action: #selector(diceButtonTapped(_:)))
        
        // Bottom right button with brand re-selection
        let brandButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(brandButtonTapped(_:)))
        
        // Add flexible spacing between the items
        let spaceItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbarItems = [priceButtonItem, spaceItem, diceButtonItem, spaceItem, brandButtonItem]
        
        navigationController?.setToolbarHidden(false, animated: false)
    }
    
    func setupUI() {
        let logoImage = UIImage(named: "logo")
        let logoImageView = UIImageView(image: logoImage)
        logoImageView.contentMode = .scaleAspectFit
        navigationItem.titleView = logoImageView
        
        setupToolbar()
        updateButtons()
    }
    
    func titleForCountButtonItem(_ items: Int) -> String {
        "Items: \(items)"
    }
    
    func unpin() {
        diceButtonItem.isEnabled = true
        likeButtons.forEach { $0.isSelected = false }
        scrollViews.unpin()
        
        updateButtons()
    }
    
    func updateButtons() {
        greenPlusButtons.forEach {
            $0.isHidden = selectedAction != .add
        }
        
        for (dislikeButton, likeButton) in zip(dislikeButtons, likeButtons) {
            let notBookmarksAction = selectedAction != .bookmarks
            dislikeButton.isHidden = notBookmarksAction || likeButton.isSelected
            likeButton.isHidden = notBookmarksAction && !likeButton.isSelected
        }
    }
    
    func updateCountButtonItem(with count: Int) {
        priceButtonItem.title = titleForCountButtonItem(count)
    }
    
    func updateItemCount() {
        updateCountButtonItem(with: itemCount)
        updatePrice()
    }
    
    func updatePrice() {
        guard let title = price?.asPrice else {
            updateCountButtonItem(with: itemCount)
            return
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.priceButtonItem.title = title
        }
    }
}
