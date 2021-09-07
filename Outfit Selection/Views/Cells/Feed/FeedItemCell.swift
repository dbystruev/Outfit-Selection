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
    var items: [Item] = []
    
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
    
    // MARK: - Inherited Methods
    /// Make sure to remove item stack view subviews
    override func prepareForReuse() {
        super.prepareForReuse()
        itemStackView?.subviews.forEach { $0.removeFromSuperview() }
    }
    
    // MARK: - Custom Methods
    /// Add items to item stack view
    /// - Parameter items: items to add
    func configure(items: [Item]) {
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
            feedItem.configureContent(with: item, showSale: kind == .sale)
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
    func configureContent(for kind: Kind, title: String, brandNames: [String]) {
        // Configure title based on type (kind)
        self.kind = kind
        titleLabel.text = title
        
        // Filter items by presense of price, old price and brand
        let itemsWithPrices = Item.all.filter { $0.price != nil && $0.oldPrice != nil }
        let itemsWithPricesByBrands = itemsWithPrices.filter { $0.branded(brandNames) }
        let filteredItems = itemsWithPricesByBrands.isEmpty ? itemsWithPrices : itemsWithPricesByBrands
        
        // Shuffle the items and make sure we don't have more than 42 of them
        let shuffledItems = filteredItems.shuffled()
        let numberOfItems = min(42, shuffledItems.count)
        
        // Make sure brand names are not empty
        guard !brandNames.isEmpty else {
            configure(items: Array(shuffledItems[..<numberOfItems]))
            return
        }
        
        // Compose roughly the similar number of items in each brand
        let maxItemsPerBrand = numberOfItems / brandNames.count + 1
        
        // Compose the items in the same order as brand names
        var items = [Item]()
        for brandName in brandNames {
            let brandedItems = shuffledItems.filter { $0.branded([brandName]) }
            let brandedItemsCount = min(brandedItems.count, maxItemsPerBrand)
            guard 0 < brandedItemsCount else { continue }
            items.append(contentsOf: brandedItems[..<brandedItemsCount])
        }
        
        configure(items: items)
    }
    
    /// Configure the view of like buttons depending on their items being in wish list
    func configureLikeButtons() {
        itemStackView.arrangedSubviews.forEach {
            ($0 as? FeedItem)?.configureLikeButton()
        }
    }
    
    // MARK: - Actions
    @IBAction func seeAllButtonTapped(_ sender: DelegatedButton) {
        delegate?.buttonTapped(self)
    }
}
