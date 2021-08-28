//
//  FeedItemCell.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 20.08.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import UIKit

class FeedItemCell: FeedCell {
    // MARK: - Outlets
    @IBOutlet weak var itemStackView: UIStackView!
    @IBOutlet weak var seeAllButton: DelegatedButton!
    
    // MARK: - Stored Properties
    /// Items to display in the item stack view
    var items: [Item] = []
    
    // MARK: - Inherited Methods
    /// Make sure to remove item stack view subviews
    override func prepareForReuse() {
        super.prepareForReuse()
        itemStackView?.subviews.forEach { $0.removeFromSuperview() }
    }
    
    // MARK: - Custom Methods
    /// Called after the items have been assigned
    func configureItems() {
        // Remove xib subview to allow space for new items
        guard 0 < items.count else { return }
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
    ///   - items: the items which needs to be displayed in the item stack view
    func configureContent(for kind: Kind, items: [Item]) {
        // Configure variables
        self.kind = kind
        let filteredItems = items.filter({ $0.price != nil && $0.oldPrice != nil })
        let numberOfItems = min(Int.random(in: 20...30), filteredItems.count)
        self.items = Array(filteredItems.shuffled()[..<numberOfItems]).sorted {
            $0.brand ?? "" < $1.brand ?? ""
        }
        
        // Configure outlets
        titleLabel.text = title
        configureItems()
    }
    
    // MARK: - Actions
    @IBAction func seeAllButtonTapped(_ sender: DelegatedButton) {
        delegate?.buttonTapped(self)
    }
}
