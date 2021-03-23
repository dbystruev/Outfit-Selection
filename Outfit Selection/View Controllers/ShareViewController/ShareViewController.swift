//
//  ShareViewController.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 23.03.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import UIKit

class ShareViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var occasionLabel: UILabel!
    
    @IBOutlet weak var shareTableView: UITableView! {
        didSet {
            shareTableView.dataSource = self
        }
    }
    
    @IBOutlet weak var topStackView: UIStackView! {
        didSet {
            // Replace first arranged subview with share view
            if let firstArrangedSubview = topStackView.arrangedSubviews.first {
                topStackView.removeArrangedSubview(firstArrangedSubview)
            }
            topStackView.insertArrangedSubview(outfitView, at: 0)
        }
    }
    
    // MARK: - Stored Properties
    /// Share view with outfit to share
    var outfitView: ShareView! {
        didSet {
            outfitView.configureLayout(logoVisible: false, outfitBottomMargin: 8, outfitTopMargin: 8, outfitWidth: 115)
        }
    }
    
    // MARK: - Inherited Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure occasion label text (could be nil)
        let text = Wishlist.occasion(outfitView.items)
        occasionLabel.isHidden = text == nil
        occasionLabel.text = text
    }
    
    /// Hide bottom tab bar when this view appears
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide bottom tab bar
        hideTabBar()
    }
    
    /// Show bottom tab bar when this view disappears
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Show bottom tab bar
        showTabBar()
    }
}
