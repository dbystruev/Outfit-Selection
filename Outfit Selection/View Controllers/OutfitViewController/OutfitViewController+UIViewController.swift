//
//  ViewController+UIViewController.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 19/06/2019.
//  Copyright © 2019 Denis Bystruev. All rights reserved.
//

import UIKit

// MARK: - UIViewController
extension OutfitViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "viewItem" else { return }
        guard let destination = segue.destination as? ItemViewController else { return }
        guard let recognizer = sender as? UIGestureRecognizer else { return }
        guard let scrollView = recognizer.view as? PinnableScrollView else { return }
        guard let image = scrollView.getImageView()?.image else { return }
        
        destination.image = image
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        scrollViews.forEach { $0.setEditing(editing) }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadImagesFromAssets()
        scrollViews.forEach { $0.delegate = self }
        setupTapGestureRecognizers()
        setupUI()
        presentMaleFemaleViewController(style: .formSheet)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.scrollViews.forEach { $0.scrollToCurrentElement() }
        }
    }
}
