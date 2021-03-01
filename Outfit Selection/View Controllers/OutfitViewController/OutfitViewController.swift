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
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet var likeButtons: [UIButton]!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet var scrollViews: [PinnableScrollView]!
    
    // MARK: - Stored Properties
    var assetCount = 0
    
    /// First appearance for view will appear
    var firstAppearance = true
    
    /// Scroll to items in this list if there are any
    var scrollToItems: [Item] = []
    
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
