//
//  OutfitViewController+UI.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 19/06/2019.
//  Copyright © 2019–2020 Denis Bystruev. All rights reserved.
//

import UIKit

// MARK: - UI
extension OutfitViewController {
    
    /// Check items to show
    func checkItemsToShow(){
        if itemsToShow.isEmpty {
            // Show the wishlistItems
            scrollwishlistItems()
            firstAppearance = false
        } else {
            // Load items to show
            scrollitemsToShow()
        }
    }
    
    /// Configure helper bubble next to hanger icon
    func configureHangerBubble() {
        guard let navView = navigationController?.view else { return }
        
        // Add hidden prompt bubble on top of the screen, above navigation controller
        hangerBubble.alpha = 0
        hangerBubble.frame = CGRect(x: 0, y: 0, width: 238, height: 58)
        hangerBubble.text = "Pin an item you like!"~
        navView.addSubview(hangerBubble)
        
        // Setup hanger bubble constraints
        hangerBubble.translatesAutoresizingMaskIntoConstraints = false
        hangerBubbleCenterYConstraint = hangerBubble.centerYAnchor.constraint(equalTo: navView.topAnchor)
        hangerBubbleTrailingConstraint = hangerBubble.trailingAnchor.constraint(equalTo: navView.leadingAnchor)
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
    
    /// Configure custom back button in navigation bar
    /// - Parameter isHidden: whether the back button should be hidden
    func configureBackBarButtonItem(isHidden: Bool) {
        // Set back bar button hidden status
        backBarButton.isHidden = isHidden
        
        // If back bar button is being hidden remove its target and don't setup further
        if isHidden {
            backBarButton.removeTarget(self, action: #selector(backBarButtonItemTapped), for: .touchUpInside)
            return
        }
        
        // Configure the back bar button
        backBarButton.titleLabel?.font = Global.Font.Onboarding.barButton
        backBarButton.contentEdgeInsets = UIEdgeInsets(top: -1, left: -6, bottom: 0, right: 0)
        backBarButton.contentHorizontalAlignment = .left
        backBarButton.contentVerticalAlignment = .center
        backBarButton.sizeToFit()
        
        // Selector for button tapped
        backBarButton.addTarget(self, action: #selector(backBarButtonItemTapped), for: .touchUpInside)
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
            scrollViews.setUnpinned(alpha: 0.25)
            
            // Make pinned scroll view's hanger buttons fully opaque
            for (hangerButton, scrollView) in zip(hangerButtons, scrollViews) {
                hangerButton.alpha = scrollView.isPinned ? 1 : 0.25
            }
        } else {
            // If hanger buttons are hidden make scroll views fully visible and don't pin any
            scrollViews.setUnpinned(alpha: 1)
            scrollViews.unpin()
        }
    }
    
    /// Configure occasions stack view
    func configureOccasions() {
        // Select new occasion if occasion selected is not set or gender is different
        lazy var selectedOccasions = Occasions
            .selectedUniqueTitle
            .gender(Gender.current)
            .sorted(by: { $0.label < $1.label })
        
        lazy var randomSelectedOccasion = selectedOccasions.randomElement()
        
        // Return if occasions isEmpty
        guard Occasions.count > 0 else { return }
        
        let gender = occasionSelected?.gender
        occasionSelected = gender == Gender.current || Gender.current == .other
        ? occasionSelected ?? randomSelectedOccasion
        : randomSelectedOccasion
        
        // Hide occasions stack view if no occasions are selected
        let isHidden = selectedOccasions.isEmpty
        occasionsStackView.isHidden = isHidden
        
        // Underline from accasion
        occasionsStackViewHeightConstraint.constant = isHidden ? 0 : 30 //44
        occasionsTopStackViewConstraint.constant = 32
        
        // Get buttons from occasions stack view
        let buttonUnderlineStackViews = occasionsStackView.arrangedSubviews.compactMap {
            $0 as? UIStackView
        }
        let buttons = buttonUnderlineStackViews.compactMap {
            $0.arrangedSubviews.first as? OccasionButton
        }
        
        guard let firstButton = buttons.first, buttons.count == buttonUnderlineStackViews.count else {
            debug("WARNING: no buttons in occasions stack view")
            return
        }
        
        // Fill existing arranged subviews with selected occasions
        for (button, occasion) in zip(buttons, selectedOccasions) {
            // Set next occasion name as button name
            button.set(occasion: occasion)
        }
        
        // If there are no enough buttons add more buttons
        if buttons.count < selectedOccasions.count {
            // Go through occasions not added to buttons yet
            for occasionIndex in buttons.count ..< selectedOccasions.count {
                // Create a button with given occasion name
                let occasion = selectedOccasions[occasionIndex]
                let button = OccasionButton(occasion)
                button.setTitleColor(firstButton.titleColor(for: .normal), for: .normal)
                button.titleLabel?.font = firstButton.titleLabel?.font
                
                // Copy all touch up inside actions for all targets from the first button
                for target in firstButton.allTargets {
                    guard let actions = firstButton.actions(forTarget: target, forControlEvent: .touchUpInside) else { continue }
                    for action in actions {
                        button.addTarget(target, action: Selector(action), for: .touchUpInside)
                    }
                }
                
                // Setup the view to underline the buttons
                let underlineView = UIView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 61, height: 1)))
                underlineView.backgroundColor = button.titleColor(for: .normal)
                underlineView.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([underlineView.heightAnchor.constraint(equalToConstant: 1)])
                
                // Setup the stack view with button and underline
                let buttonUnderlineStackView = UIStackView(arrangedSubviews: [button, underlineView])
                buttonUnderlineStackView.axis = .vertical
                
                // Add the button and underline to occasions stack view
                occasionsStackView.addArrangedSubview(buttonUnderlineStackView)
            }
            // If there are too many buttons remove remaining
        } else if selectedOccasions.count < buttons.count {
            // How many buttons to remove
            let buttonsToRemoveCount = buttons.count - selectedOccasions.count
            
            // The actual buttons to remove
            let buttonsToRemove = buttonUnderlineStackViews.reversed().enumerated().filter {
                index, _ in index < buttonsToRemoveCount
            }
            
            // Remove the buttons
            buttonsToRemove.forEach { $0.element.removeFromSuperview() }
        }
        
        // Update occasions
        updateOccasionsUI(selectedTitle: occasionSelected?.title)
    }
    
    /// Configure refresh bubble once in the beginning
    func configureShuffleBubble() {
        shuffleBubble?.alpha = 0
        shuffleBubble?.text = "Check out the next outfit"~
        
        // Add tap gesture on refresh bubble
        shuffleBubble?.addTapOnce(target: self, action: #selector(shuffleBubbleTapped))
    }
    
    /// Hide hanger and refresh bubbles immediately
    func hideBubbles() {
        shouldHideBubbles = true
        hangerBubble.alpha = 0
        shuffleBubble?.alpha = 0
    }
    
    /// Load images for some items in Item.all filtered by category in Category.all.count into scroll views
    /// - Parameter corneredSubcategoryIDs: subcategory IDs from occasion
    func loadImages(matching corneredSubcategoryIDs: [[Int]] = Corners.empty) {
        
        // Check Scroll views is nil
        guard let scrollViews = scrollViews else {
            debug("WARNING: scrollViews is nil" )
            return
        }
        
        // Clear scroll views
        for scrollView in scrollViews {
            if !scrollView.isPinned {
                scrollView.clear()
            }
        }
        
        // Load images from view models into scroll view
        ItemManager.shared.loadImages(into: scrollViews, matching: corneredSubcategoryIDs)
        
        // Update the number of images loaded
        updateItemCount()
    }
    
    func pin() {
        shuffleButton.isEnabled = false
        scrollViews.pin()
    }
    
    /// Scroll outfit's scroll views to the given items
    /// - Parameters:
    ///   - scrollItems: the items to scroll the scroll views to
    ///   - ordered: if true assume IDs are given in the same order as scroll views
    ///   - completion: the block of code to be executed when scrolling ends
    func scrollTo(items scrollItems: Items, ordered: Bool, completion: ((Bool) -> Void)? = nil) {
        // Scroll to the given item IDs
        scrollViews?.scrollToElements(with: scrollItems.IDs, ordered: ordered, completion: completion)
        // TODO: Check this method, when all items download and shuffle buton tap
        //debug(scrollItems)
    }
    
    /// Scroll outfit's scroll views to the given occasion
    /// - Parameter occasion: the occasion to scroll the scroll views to
    func scrollTo(occasion: Occasion) {
        
        // Load images into the outfit view controller's scroll views
        loadImages(matching: occasion.subcategoryIDs)
        
        // Go through the corners and select items for each corner
        let occasionItems = itemsByCorner.compactMap { $0.randomElement() }
        
        // Check that we didn't lose any items while removing items
        guard occasionItems.count == itemsByCorner.count else {
            debug("WARNING: Don't have enough items to match occasion \(occasion)")
            return
        }
        
        // Scroll to the selected items
        scrollTo(items: occasionItems, ordered: true)
        
        // Update selected occasion property and UI
        occasionSelected = occasion
    }
    
    /// Scroll to random items
    /// - Parameter duration: duration of each scroll, 1 second by default
    func scrollToRandomItems(duration: TimeInterval = 1) {
        scrollViews.forEach {
            if !$0.isPinned {
                $0.scrollToRandom(duration: duration)
            }
        }
    }
    
    /// Load and scrol to items from itemsToShow
    func scrollitemsToShow() {
        
        //Check items and scrollViews
        guard !itemsToShow.isEmpty && scrollViews?.itemCount != nil else { return }
        
        if let itemCount = scrollViews?.itemCount, itemCount < itemsToShow.count || Global.TabBar.status.found
        {
            loadImages()
        }
        
        // Scrol to downloaded imagesitemsToShow
        scrollTo(items: itemsToShow, ordered: false) { [self] completion in
            guard completion else { return }
            // TabBar status
            Global.TabBar.status.found = false
            
            // Set lock button shuffle
            shuffleButtonCheck(lock: true, alpha: 0.25)
            
            // Update occasions
            updateOccasionsUI(selectedTitle: occasionSelected?.title)
            
            // Hide hints
            hideBubbles()
        }
    }
    
    /// Scroll to wishlist items or occasions selected / random elements on first appearance
    func scrollwishlistItems() {
        if wishlistItems.isEmpty {
            if firstAppearance {
                guard let occasionSelected = occasionSelected else {
                    scrollToRandomItems()
                    return
                }
                scrollTo(occasion: occasionSelected)
            }
        } else {
            scrollTo(items: wishlistItems, ordered: false)
            if let matchingOccasion = Occasions.with(items: wishlistItems).randomElement() {
                occasionSelected = matchingOccasion
            } else {
                updateOccasionsUI(selectedTitle: wishlistName)
            }
            wishlistItems.removeAll()
        }
    }
    
    /// Set visibility of items with subcategories given in the same order as scroll views
    /// - Parameters:
    ///   - corneredSubcategories: the item subcategories to set visibility of
    ///   - visible: if true show matching items and hide non-matching items, if false — the other way around
    func setElements(in corneredSubcategories: [[Int]], visible: Bool) {
        // Set visibility of items in the scroll views
        scrollViews?.setElements(in: corneredSubcategories, visible: visible)
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
            
            if self.showShuffleBubble {
                UIView.animate(withDuration: 2) {
                    self.shuffleBubble?.alpha = 1
                }
            }
        }
    }
    
    /// Show or hide animate shaffle button
    func shuffleButtonAnimate(setAnimation: Bool) {
        if setAnimation {
            savedTransform = shuffleButton.transform
            shuffleButton.setImage(UIImage(named: "refresh"), for: .disabled)
            UIView.animate(withDuration: 1, delay: 0, options: .repeat) {
                self.shuffleButton.transform = self.shuffleButton.transform.rotated(by: CGFloat.pi)
            }
        } else {
            shuffleButton?.transform = savedTransform ?? shuffleButton.transform
            shuffleButton?.setImage(UIImage(named: "shuffle"), for: .disabled)
            shuffleButton?.layer.removeAllAnimations()
        }
    }
    
    /// Show / hide shuffleButton
    func shuffleButtonCheck(lock: Bool, alpha: Double = 1) {
        shuffleButton.alpha = lock ? alpha : 1
        shuffleButton.isEnabled = lock ? false : true
    }
    
    /// Show / hide subcategory labels with information about currently presented look
    func toggleSubcategoryLabels() {
        // Toggle visibility of subcategory labels
        showSubcategoryLabels.toggle()
    }
    
    func unpin() {
        hangerButtons.forEach { $0.isSelected = false }
        shuffleButton.isEnabled = true
        scrollViews.unpin()
    }
    
    func updateItemCount() {
        updatePriceLabelWithItemCount(with: itemCount)
        updateUI()
    }
    
    func updatePriceLabelWithItemCount(with count: Int) {
        // NOTE: Item count has been removed by Kim's request
        // priceLabel.text = "Items"~ + ": \(count)"
    }
    
    /// Update subcategory labels with information about currently presented look
    func updateSubcategoryLabels() {
        if let occasion = occasionSelected {
            // Go through each item and show its subcategory in occasion
            let subcategoryIDsAndLabels = zip(occasion.subcategoryIDs, subcategoryLabels)
            for (item, (subcategoryIDs, subcategoryLabel)) in zip(visibleItems, subcategoryIDsAndLabels) {
                let itemSubcategories = item.subcategoryIDs.categoryIDsDescription
                let occasionSubcategories = subcategoryIDs.categoriesDescription
                let warning = item.isMatching(subcategoryIDs) ? "" : "!!! "
                subcategoryLabel.text = "\(warning)\(occasionSubcategories) — \(itemSubcategories)"
            }
        }
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
            self.likeButton.isSelected = Wishlist.contains(self.visibleItems) == true
        }
    }
    
    /// Update occasions stack view when user taps an occasion button
    /// - Parameter selectedTitle: the title to select, if nil — use title of selected occasion
    func updateOccasionsUI(selectedTitle: String?) {
        // If selected title is given, underline it
        let titleToUnderline = selectedTitle ?? occasionSelected?.title
        
        // Get all occasion buttons and underlines
        let buttonUnderlineStackViews = occasionsStackView
            .arrangedSubviews
            .compactMap { $0 as? UIStackView }
        let buttons = buttonUnderlineStackViews
            .compactMap { $0.arrangedSubviews.first as? OccasionButton }
        let underlines = buttonUnderlineStackViews.compactMap { $0.arrangedSubviews.last }
        
        // Go through all occastion buttons and underline the selected one
        for (button, underline) in zip(buttons, underlines) {
            // Set button opacity depending on whether it is selected
            let isSelected = button.title == titleToUnderline
            
            // Check and set alpha and isEnabled for buttons
            if !occasionItemsAreLoading {
                button.alpha = isSelected ? 1 : 0.75
                // Unlock a button
                button.isEnabled = true
            } else {
                button.alpha = isSelected ? 1 : 0.25
                // Lock a button
                button.isEnabled = false
            }
            
            // Check itemsToShow and hide all underline, when itemToShow avaliable.
            if itemsToShow.isEmpty {
                
                // Set button underline visibility depending on whether the button is selected
                underline.isHidden = !isSelected
            } else {
                underline.isHidden = true
                button.alpha = 0.75
                
            }
            
            // Scroll to selected button
            if isSelected {
                occasionsScrollView.scrollRectToVisible(
                    button.convert(button.bounds, to: occasionsScrollView).insetBy(dx: -16, dy: 0),
                    animated: true
                )
            }
        }
    }
    
    /// Updates price label
    func updatePriceUI() {
        guard 0 < price else {
            updatePriceLabelWithItemCount(with: itemCount)
            return
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            self.priceLabel.text = "Outfit price"~ + ": \(self.price.asPrice(feedID: self.items.first?.feedID))"
        }
    }
    
    /// Updates like button, total price, and subcategory labels
    func updateUI() {
        // Update like button
        updateLikeButton()
        
        // Update price label
        updatePriceUI()
        
        // Update subcategory labels
        updateSubcategoryLabels()
    }
    
    /// Reload ocassions
    @objc func updatedOccasions() {
        
        // Return to main
        DispatchQueue.main.async {
            // Configure occasions
            self.configureOccasions()
        }

        // Reload items from the server for changed occasion
        NetworkManager.shared.reloadItems(from: self.occasionSelected) { [weak self] success in
            if success == true {} else {
                debug("ERROR reloading items for", Gender.current)
                
                // Set status occasions elements
                self?.occasionItemsAreLoading = false
                
                // Load items occasion selected before
                ItemManager.shared.loadItems(for: Occasion.selected) { success in
                    guard success == true else {
                        debug("ERROR loading items for", Gender.current)
                        return
                    }
                }
            }
        }
        
        // Load images for items
        ItemManager.shared.loadImages(filteredBy: Gender.current, cornerLimit: 1) { [weak self] current, total in
            // Wait until all images are loaded
            guard current == total else { return }
            
            // Make sure we clear occasion items loading flag in any case
            defer {
                self?.occasionItemsAreLoading = false
            }
            
            // Check for self availability
            guard let self = self else {
                debug("ERROR: self is not available")
                return
            }
            
            // Scroll to newly selected occasion
            DispatchQueue.main.async {
                self.scrollTo(occasion: self.occasionSelected!)
            }
        }
    }
    
}
