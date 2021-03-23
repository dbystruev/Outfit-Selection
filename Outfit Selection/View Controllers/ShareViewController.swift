//
//  ShareViewController.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 23.03.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import UIKit

class ShareViewController: UIViewController {
    
    // MARK: - Stored Properties
    /// Share view with outfit to share
    var shareView: ShareView!
    
    // MARK: - Inherited Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        debug(shareView.pictureImageViews.count)
    }
    
    /// Hide bottom tab bar when this view appears
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide tab bar at the bottom
        hideTabBar()
    }
}
