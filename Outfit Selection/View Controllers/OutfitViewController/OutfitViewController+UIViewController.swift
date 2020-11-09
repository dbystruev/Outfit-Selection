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
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        buttons.forEach {
            $0.isHidden = !editing
            $0.setEditing(action: selectedAction)
        }
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
