//
//  OutfitViewController.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 19/06/2019.
//  Copyright © 2019–2020 Denis Bystruev. All rights reserved.
//

import UIKit

class OutfitViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var hangerBarButtonItem: UIBarButtonItem!
    @IBOutlet var hangerButtons: [UIButton]!
    @IBOutlet weak var iconsStackView: UIStackView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var refreshBubble: RefreshBubble! {
        didSet {
            configureRefreshBubble()
        }
    }
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet var scrollViews: [PinnableScrollView]!
    @IBOutlet weak var topStackView: UIStackView!
    
    // MARK: - Stored Properties
    /// First appearance for view will appear
    var firstAppearance = true
    
    /// Heper bubble next to hanger icon
    let hangerBubble = HangerBubble()
    
    /// Constraint for the vertical center of hanger bubble
    var hangerBubbleCenterYConstraint: NSLayoutConstraint!
    
    /// Confstraint for the trailing of hanger bubble
    var hangerBubbleTrailingConstraint: NSLayoutConstraint!
    
    /// Scroll to items in this list if there are any
    var scrollToItems: [Item] = []
    
    /// Share view with current outfit
    var shareView: ShareView?
    
    /// True when both hanger and refresh bubbles should be hidden
    var shouldHideBubbles = false
    
    /// True if hanger bubble should be shown, false otherwise
    var showHangerBubble = true {
        didSet {
            hangerBubble.isHidden = !showHangerBubble
        }
    }
    
    /// True if hanger buttons should be shown, false otherwise
    var showHangerButtons = false {
        didSet {
            configureHangerButtons()
        }
    }
    
    /// True when we want to show refresh bubble, false otherwise
    var showRefreshBubble = true {
        didSet {
            refreshBubble?.isHidden = !showRefreshBubble
        }
    }
    
    // MARK: - Computed Properties
    var itemCount: Int {
        scrollViews.reduce(0) { $0 + $1.itemCount }
    }
    
    /// Item indexes for current image views
    var itemIndexes: [Int] {
        scrollViews.compactMap({ $0.getImageView()?.tag }).filter { 0 <= $0 }
    }
    
    /// Items for current image views
    var items: [Item] {
        itemIndexes.compactMap { 0 <= $0 && $0 < Item.all.count ? Item.all[$0] : nil }
    }
    
    var price: Double {
        var amount = 0.0
        for scrollView in scrollViews {
            let itemPrice = scrollView.item?.price ?? 0
            amount += itemPrice
        }
        return amount
    }
}
