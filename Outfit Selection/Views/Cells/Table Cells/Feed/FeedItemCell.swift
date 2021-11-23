//
//  FeedItemCell.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 20.08.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import UIKit

class FeedItemCell: FeedBaseCell {
    // MARK: - Outlets
    @IBOutlet weak var itemStackView: UIStackView!
    @IBOutlet weak var seeAllButton: DelegatedButton!
    
    // MARK: - Stored Properties
    /// Items to display in the item stack view
    var items: Items = []
    
    /// The name of the feed
    var name: String?
    
    // MARK: - Inherited Properties
    override var delegate: ButtonDelegate? {
        get { super.delegate }
        set {
            super.delegate = newValue
            itemStackView.arrangedSubviews.forEach {
                ($0 as? FeedItem)?.delegate = newValue
            }
        }
    }
    
    override var title: String? {
        get { name ?? super.title }
    }
    
    // MARK: - Inherited Methods
    /// Make sure to remove item stack view subviews
    override func prepareForReuse() {
        super.prepareForReuse()
        itemStackView?.subviews.forEach { $0.removeFromSuperview() }
    }
    
    // MARK: - Custom Methods
    /// Add items to item stack view
    /// - Parameters:
    ///   - items: items to add
    ///   - isInteractive: if true allow clicks on buttons and items, if not — disable them
    func configure(items: Items, isInteractive: Bool) {
        // Make sure items are not empty
        guard 0 < items.count else { return }
        self.items = items
        
        // Remove xib subview to allow space for new items
        itemStackView.subviews.forEach { $0.removeFromSuperview() }
        
        // Add new items to the items stack view
        for item in items {
            // Insert feed item subviews into item stack view
            guard let feedItem = FeedItem.instanceFromNib() else {
                debug("Can't instantiate FeedItem from Nib")
                return
            }
            itemStackView.addArrangedSubview(feedItem)
            feedItem.configureContent(with: item, showSale: kind == .sale, isInteractive: isInteractive)
        }
        
        // Configure constraints for the first item — the rest will follow suit
        guard let item = itemStackView.arrangedSubviews.first else { return }
        let heightConstraint = NSLayoutConstraint(
            item: item, attribute: .height, relatedBy: .equal, toItem: .none, attribute: .notAnAttribute, multiplier: 1, constant: FeedItemCell.itemHeight
        )
        let widthConstraint = NSLayoutConstraint(
            item: item, attribute: .width, relatedBy: .equal, toItem: .none, attribute: .notAnAttribute, multiplier: 1, constant: FeedItemCell.itemWidth
        )
        NSLayoutConstraint.activate([heightConstraint, widthConstraint])
    }
    
    /// Called when we know for sure what items we want to display
    /// - Parameters:
    ///   - kind: cell's type
    ///   - title: cell's title
    ///   - brandNames: put items with given brand names first
    ///   - items: the items to configure the content for
    ///   - isInteractive: if true allow clicks on buttons and items, if not — disable them
    func configureContent(for kind: FeedKind, title: String, brandNames: [String], items: Items, isInteractive: Bool) {
        // Configure kind, title, and `see all` button visibility
        self.kind = kind
        name = title
        seeAllButton.isHidden = !isInteractive
        titleLabel.text = title
        
        // If items are given skip further configuration
        guard items.isEmpty else {
            configure(items: items, isInteractive: isInteractive)
            return
        }
        
        // Get items from Item.all and filter them by presense of price, old price and brand
        let itemsWithOldPrices = Items.values.filter { $0.oldPrice != nil }
        let itemsWithOldPricesByBrands = itemsWithOldPrices.filter { $0.branded(brandNames) }
        let filteredItems = itemsWithOldPricesByBrands.isEmpty ? itemsWithOldPrices : itemsWithOldPricesByBrands
        
        // Shuffle the items and make sure we don't have more than 42 of them
        let shuffledItems = filteredItems.shuffled()
        let numberOfItems = min(42, shuffledItems.count)
        
        // Make sure brand names are not empty
        guard !brandNames.isEmpty else {
            configure(items: Array(shuffledItems[..<numberOfItems]), isInteractive: isInteractive)
            return
        }
        
        // Compose roughly the similar number of items in each brand
        let maxItemsPerBrand = numberOfItems / brandNames.count + 1
        
        // Compose the items in the same order as brand names
        var orderedItems = Items()
        for brandName in brandNames {
            let brandedItems = shuffledItems.filter { $0.branded([brandName]) }
            let brandedItemsCount = min(brandedItems.count, maxItemsPerBrand)
            guard 0 < brandedItemsCount else { continue }
            orderedItems.append(contentsOf: brandedItems[..<brandedItemsCount])
        }
        
        configure(items: orderedItems, isInteractive: isInteractive)
    }
    
    /// Configure the view of like buttons depending on their items being in wish list
    func configureLikeButtons() {
        itemStackView.arrangedSubviews.forEach {
            ($0 as? FeedItem)?.configureLikeButton(isInteractive: true)
        }
    }
    
    // MARK: - Actions
    @IBAction func seeAllButtonTapped(_ sender: DelegatedButton) {
        delegate?.buttonTapped(self)
    }
}
