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
    func getScreenshot(of view: UIView) -> UIImage? {
        // Set screenshot size to Instagram story size 1080x1920
        // https://www.picmonkey.com/blog/size-matters-instagram-photo-sizes-made-easy
        let size = CGSize(width: 1080, height: 1920)
        
        // Setup logo image view
        let logoImage = UIImage(named: "logo")
        let logoImageView = UIImageView(image: logoImage)
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.frame.origin.y -= 12
        logoImageView.frame.size.width = view.frame.size.width
        
        // Add the logo image view to the view
        view.addSubview(logoImageView)
        
        // Get the renderer
        let renderer = UIGraphicsImageRenderer(size: size)
        let image = renderer.image { context in
            // Draw the screenshot view
            view.drawHierarchy(in: CGRect(origin: CGPoint(), size: size), afterScreenUpdates: true)
        }
        
        debug("logo image =", logoImage, "logoImageView.frame = \(logoImageView.frame)", "image = \(image)")
        
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
        refreshButton.isEnabled = false
        scrollViews.pin()
    }
    
    /// Scroll outfit's scroll views to the given items
    /// - Parameter items: the items to scroll the scroll views to
    func scrollTo(items: [Item]) {
        let tags = items.map { $0.itemIndex }
        scrollViews?.scrollToElements(withTags: tags)
    }
    
    /// Scroll to random items
    /// - Parameter duration: duration of each scroll, 1 second by default
    func scrollToRandomItems(duration: TimeInterval = 1) {
        scrollViews.forEach {
            if !$0.isPinned {
                $0.scrollToRandomElement(duration: duration)
            }
        }
        
        // Update like button and price
        updateUI()
    }
    
    func setupUI() {
        // Hide all like buttons
        likeButtons.forEach { $0.isHidden = true }
    }
    
    func unpin() {
        likeButtons.forEach { $0.isSelected = false }
        refreshButton.isEnabled = true
        scrollViews.unpin()
    }
    
    func updatePriceLabelWithItemCount(with count: Int) {
        priceLabel.text = "Items: \(count)"
    }
    
    func updateItemCount() {
        updatePriceLabelWithItemCount(with: itemCount)
        updateUI()
    }
    
    /// Update layout when rotating
    /// - Parameter isHorizontal: true if layout should be horizontal, false otherwise
    func updateLayout(isHorizontal: Bool) {
        iconsStackView.alignment = isHorizontal ? .center : .fill
        iconsStackView.axis = isHorizontal ? .vertical : .horizontal
        iconsStackView.distribution = isHorizontal ? .fillEqually : .fill
        topStackView.alignment = isHorizontal ? .center : .fill
        topStackView.axis = isHorizontal ? .horizontal : .vertical
        topStackView.distribution = isHorizontal ? .fillEqually : .fill
    }
    
    /// Updates like button
    func updateLikeButton() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.likeButton.isSelected = Wishlist.contains(self.items) == true
        }
    }
    
    /// Updates price label
    func updatePrice() {
        guard 0 < price else {
            updatePriceLabelWithItemCount(with: itemCount)
            return
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.priceLabel.text = "Outfit price: \(self.price.asPrice)"
        }
    }
    
    /// Updates like button and price
    func updateUI() {
        // Update like button
        updateLikeButton()
        
        // Update price label
        updatePrice()
    }
}
