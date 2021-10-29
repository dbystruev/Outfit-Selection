//
//  OutfitViewController.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 19/06/2019.
//  Copyright © 2019–2020 Denis Bystruev. All rights reserved.
//

import UIKit

class OutfitViewController: LoggingViewController {
    // MARK: - Outlets
    @IBOutlet weak var hangerBarButtonItem: UIBarButtonItem!
    @IBOutlet var hangerButtons: [UIButton]!
    @IBOutlet weak var iconsStackView: UIStackView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var occasionsStackView: UIStackView!
    @IBOutlet weak var occasionsStackViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet var scrollViews: [PinnableScrollView]!
    @IBOutlet weak var shuffleBubble: RefreshBubble! {
        didSet {
            configureShuffleBubble()
        }
    }
    @IBOutlet weak var shuffleButton: UIButton!
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
    
    /// Occasion which is currently selected by the user
    weak var occasionSelected: Occasion? {
        didSet {
            updateOccasionsUI()
        }
    }
    
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
    var showShuffleBubble = false {
        didSet {
            shuffleBubble?.isHidden = !showShuffleBubble
        }
    }
    
    // MARK: - Computed Properties
    /// Items in all scroll views' image views, including currently non-visible
    var items: [Item] {
        itemsByCorner.flatMap { $0 }
    }
    
    /// Items in all scroll views' image views, including currently non-visible, ordered by corners
    var itemsByCorner: [[Item]] {
        scrollViews.map { $0.items }
    }
    
    /// The number of items in all scroll views
    var itemCount: Int {
        scrollViews.reduce(0) { $0 + $1.itemCount }
    }
    
    /// Total price of all visible items
    var price: Double {
        var amount = 0.0
        for scrollView in scrollViews {
            let itemPrice = scrollView.item?.price ?? 0
            amount += itemPrice
        }
        return amount
    }
    
    /// Items for currently visible image views
    var visibleItems: [Item] {
        scrollViews.compactMap({ $0.getImageView()?.item })
    }
}
