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
    @IBOutlet weak var occasionsScrollView: UIScrollView!
    @IBOutlet weak var occasionsStackView: UIStackView!
    @IBOutlet weak var occasionsStackViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet var scrollViews: PinnableScrollViews!
    @IBOutlet weak var shuffleBubble: RefreshBubble! {
        didSet {
            configureShuffleBubble()
        }
    }
    @IBOutlet weak var shuffleButton: UIButton!
    @IBOutlet var subcategoryLabels: [UILabel]! {
        didSet {
            subcategoryLabels.forEach {
                $0.clipsToBounds = true
                $0.layer.cornerRadius = 8
            }
        }
    }
    @IBOutlet weak var topStackView: UIStackView!
    
    // MARK: - Stored Properties
    /// Shuffle is allowed when enough item images are loaded
    var allowShuffle = true
    
    /// First appearance for view will appear
    var firstAppearance = true
    
    /// Heper bubble next to hanger icon
    let hangerBubble = HangerBubble()
    
    /// Constraint for the vertical center of hanger bubble
    var hangerBubbleCenterYConstraint: NSLayoutConstraint!
    
    /// Confstraint for the trailing of hanger bubble
    var hangerBubbleTrailingConstraint: NSLayoutConstraint!
    
    var itemsToShow: Items?
    
    /// True if occasion elements are being loaded
    var occasionItemsAreLoading = false
    
    /// Share view with current outfit
    var shareView: ShareView?
    
    /// True when both hanger and refresh bubbles should be hidden
    var shouldHideBubbles = false
    
    /// True if hanger bubble should be shown, false otherwise
    var showHangerBubble = false {
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
    var showShuffleBubble = true {
        didSet {
            shuffleBubble?.isHidden = !showShuffleBubble
        }
    }
    
    /// True when subcategory labels should be shown
    var showSubcategoryLabels = false {
        didSet {
            subcategoryLabels.forEach { $0.isHidden = !showSubcategoryLabels }
            updateSubcategoryLabels()
        }
    }
    
    /// Wishlist items to scroll to
    var wishlistItems: Items = []
    
    /// The name of wishlist if any
    var wishlistName: String?
    
    // MARK: - Computed Properties
    /// Items in all scroll views' image views, including currently non-visible
    var items: Items {
        itemsByCorner.flatMap { $0 }
    }
    
    /// Items in all scroll views' image views, including currently non-visible, ordered by corners
    var itemsByCorner: [Items] {
        scrollViews.map { $0.items }
    }
    
    /// The number of items in all scroll views
    var itemCount: Int {
        scrollViews.reduce(0) { $0 + $1.itemCount }
    }
    
    /// Occasion which is currently selected by the user
    var occasionSelected: Occasion? {
        get { Occasion.selected }
        set {
            Occasion.selected = newValue ?? Occasion.selected
            updateOccasionsUI(selectedTitle: occasionSelected?.title)
        }
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
    var visibleItems: Items {
        scrollViews.compactMap({ $0.getImageView()?.item })
    }
}
