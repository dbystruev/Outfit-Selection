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
        guard segue.identifier == "itemViewControllerSegue" else { return }
        guard let destination = segue.destination as? ItemViewController else { return }
        guard let recognizer = sender as? UIGestureRecognizer else { return }
        guard let scrollView = recognizer.view as? PinnableScrollView else { return }
        guard let imageView = scrollView.getImageView() else { return }
        
        destination.image = imageView.image
        destination.itemIndex = imageView.tag
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        scrollViews.forEach { $0.setEditing(editing) }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        assetCount = 0 // ItemManager.shared.loadImagesFromAssets(into: scrollViews)
        scrollViews.forEach { $0.delegate = self }
        setupGestures()
        setupUI()
        
        // Load images into the outfit view controller's scroll views
        loadImages()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Scroll to wishlist items or random elements on first appearance
        if scrollToItems.isEmpty {
            if firstAppearance {
                scrollToRandomItems()
            }
        } else {
            scrollTo(items: scrollToItems)
            scrollToItems.removeAll()
        }
        
        firstAppearance = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.scrollViews.forEach { $0.scrollToCurrentElement() }
            self.updateUI()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
    }
}
