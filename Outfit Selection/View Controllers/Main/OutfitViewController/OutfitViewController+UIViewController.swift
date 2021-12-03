//
//  ViewController+UIViewController.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 19/06/2019.
//  Copyright © 2019–2020 Denis Bystruev. All rights reserved.
//

import UIKit

// MARK: - UIViewController
extension OutfitViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        
        case ItemViewController.segueIdentifier:
            guard let destination = segue.destination as? ItemViewController else { return }
            guard let recognizer = sender as? UIGestureRecognizer else { return }
            guard let scrollView = recognizer.view as? PinnableScrollView else { return }
            guard let imageView = scrollView.getImageView() else { return }
            destination.configure(with: imageView.item, image: imageView.image)
            
        case "shareViewControllerSegue":
            guard let destination = segue.destination as? ShareViewController else { return }
            destination.outfitView = shareView
            
        default:
            return
        }
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        scrollViews.forEach { $0.setEditing(editing) }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure the buttons with hungers next to them
        configureHangerButtons()
                
        // Configure hanger icon in navigation bar
        configureHangerBarButtonItem()
        
        // Configure the bubble next to hanger icon
        configureHangerBubble()
        
        // Configure occasions stack view
        configureOccasions()
        
        // Configure single, double, and triple tap gestures
        configureTapGestures()
        
        // Configure navigation controller's bar font
        navigationController?.configureFont()
        
        // Use self as scroll view delegate for each scroll view
        scrollViews.forEach { $0.delegate = self }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Scroll to wishlist items or occasions selected / random elements on first appearance
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
        
        firstAppearance = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.scrollViews.forEach {
                $0.scrollToRecent()
            }
        }
        
        // Configure constraints for hanger bubble
        configureHangerBubbleConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Show the helper bubbles        
        showBubbles()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        hideBubbles()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let frame = view.frame
        updateLayout(isHorizontal: frame.height < frame.width)
    }
}
