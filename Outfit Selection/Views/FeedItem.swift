//
//  FeedItem.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 20.08.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import UIKit

class FeedItem: UIView {
    
    // MARK: - Outlets
    @IBOutlet weak var brandLabel: UILabel!
    @IBOutlet weak var itemButton: DelegatedButton!
    @IBOutlet weak var itemImageView: ItemImageView!
    @IBOutlet weak var likeButton: WishlistButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var oldPriceLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    // MARK: - Class Methods
    class func instanceFromNib() -> FeedItem? {
        nib.instantiate(withOwner: nil, options: nil).first as? FeedItem
    }
    
    // MARK: - Stored Properties
    /// Button delegate to send a message when something was tapped
    var delegate: ButtonDelegate?
    
    /// The item being currently displayed
    weak var item: Item?
    
    // MARK: - Custom Methods
    /// Configure view content based on the item given
    /// - Parameters:
    ///   - item: the item to configure content for
    ///   - showSale: if true show strikethrough old price if available
    ///   - isInteractive: if true allow clicks on buttons and items, if not — disable them
    func configureContent(with item: Item, showSale: Bool = false, isInteractive: Bool) {
        // Set the item being currently displayed
        self.item = item
        
        // Configure the view of like button depending on item being in wish list
        configureLikeButton(isInteractive: isInteractive)
        
        // Load the first picture for item into item image view
        itemImageView.configure(with: item)
        
        // Configure labels
        brandLabel.text = item.brand?.capitalizingFirstLetter
        nameLabel.text = item.nameWithoutVendor
        oldPriceLabel.isHidden = !showSale
        priceLabel.text = item.price.asPrice
        
        // Set strikethrough red font for old price
        guard let oldPrice = item.oldPrice?.asPrice else { return }
        let attributedOldPrice = NSMutableAttributedString(string: oldPrice)
        attributedOldPrice.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributedOldPrice.length))
        oldPriceLabel.attributedText = attributedOldPrice
    }
    
    /// Configure the view of like button depending on item being in wish list
    /// - Parameter isInteractive: if true allow clicks, if not — disable it
    func configureLikeButton(isInteractive: Bool) {
        likeButton?.isHidden = !isInteractive
        if let item = item, isInteractive {
            likeButton?.configure(for: item)
        }
    }
    
    // MARK: - Actions
    /// Called when user taps anywhere except like (wislist) button
    /// - Parameter sender: the item button which was tapped
    @IBAction func itemButtonTapped(_ sender: DelegatedButton) {
        delegate?.buttonTapped(self)
    }
    
    /// Called when user taps on like (wishlist) button
    /// - Parameter sender: the like (wishlist) button which was tapped
    @IBAction func likeButtonTapped(_ sender: WishlistButton) {
        guard let item = item else { return }
        sender.addToWishlistButtonTapped(for: item)
    }
    
}
