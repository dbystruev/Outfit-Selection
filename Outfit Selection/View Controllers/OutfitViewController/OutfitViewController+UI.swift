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
    /// Configure helper bubble next to hanger icon
    func configureHangerBubble() {
        guard let navigationController = navigationController else { return }
        
        // Add hidden prompt bubble on top of the screen, above navigation controller
        hangerBubble.alpha = 0
        hangerBubble.frame = CGRect(x: 0, y: 0, width: 238, height: 58)
        hangerBubble.text = "Pin an item you like!"
        navigationController.view.addSubview(hangerBubble)
        
        // Setup hanger bubble constraints
        hangerBubble.translatesAutoresizingMaskIntoConstraints = false
        hangerBubbleCenterYConstraint = hangerBubble.centerYAnchor.constraint(equalTo: navigationController.view.topAnchor)
        hangerBubbleTrailingConstraint = hangerBubble.trailingAnchor.constraint(equalTo: navigationController.view.leadingAnchor)
        NSLayoutConstraint.activate([
            hangerBubbleCenterYConstraint,
            hangerBubble.heightAnchor.constraint(equalToConstant: 58),
            hangerBubbleTrailingConstraint,
            hangerBubble.widthAnchor.constraint(equalToConstant: 238),
        ])
        
        // Add tap gesture on hanger bubble
        hangerBubble.addTapOnce(target: self, action: #selector(hangerBubbleTapped))
    }
    
    /// Configure hanger icon in navigation bar
    func configureHangerBarButtonItem() {
        let customView = UIImageView(image: UIImage(named: "hanger"))
        hangerBarButtonItem.customView = customView
        customView.addTapOnce(target: self, action: #selector(hangerBarButtonItemTapped(_:)))
    }
    
    /// Configure constraints for hanger bubble
    func configureHangerBubbleConstraints() {
        guard let hangerView = hangerBarButtonItem.customView else { return }
        let point = hangerView.convert(CGPoint(x: -2, y: hangerView.center.y + 1), to: navigationController?.view)
        hangerBubbleCenterYConstraint.constant = point.y
        hangerBubbleTrailingConstraint.constant = point.x
    }
    
    /// Configure hanger buttons visibility and opacity
    func configureHangerButtons() {
        // Show or hide all hanger buttons
        hangerButtons.forEach { $0.isHidden = !showHangerButtons }
        
        if showHangerButtons {
            // Make unpinned scroll views half transparent
            scrollViews.setUnpinned(alpha: 0.5)
            
            // Make pinned scroll view's hanger buttons fully opaque
            for (hangerButton, scrollView) in zip(hangerButtons, scrollViews) {
                hangerButton.alpha = scrollView.isPinned ? 1 : 0.5
            }
        } else {
            // If hanger buttons are hidden make scroll views fully visible and don't pin any scroll views
            scrollViews.setUnpinned(alpha: 1)
            scrollViews.unpin()
        }
        
    }
    
    /// Configure refresh bubble once in the beginning
    func configureRefreshBubble() {
        refreshBubble?.alpha = 0
        refreshBubble?.text = "Check out the next outfit"
        
        // Add tap gesture on refresh bubble
        refreshBubble?.addTapOnce(target: self, action: #selector(refreshBubbleTapped))
    }
    
    /// Hide hanger and refresh bubbles immediately
    func hideBubbles() {
        shouldHideBubbles = true
        hangerBubble.alpha = 0
        refreshBubble?.alpha = 0
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
    
    /// Show hanger and refresh bubbles after initial pause
    /// - Parameter pause: initial pause in seconds to wait before showing the bubbles
    func showBubbles(after pause: TimeInterval = 2) {
        shouldHideBubbles = false
        
        // Show hanger bubble in 2 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + pause) {
            // Check that outfit view controller is visible
            guard !self.shouldHideBubbles else { return }

            if self.showHangerBubble {
                UIView.animate(withDuration: 2) {
                    self.hangerBubble.alpha = 1
                }
            }
            if self.showRefreshBubble {
                UIView.animate(withDuration: 2) {
                    self.refreshBubble?.alpha = 1
                }
            }
        }
    }
    
    func unpin() {
        hangerButtons.forEach { $0.isSelected = false }
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
