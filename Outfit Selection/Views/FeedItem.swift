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
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var likeButton: DelegatedButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var oldPriceLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    // MARK: - Class Properties
    class var nib: String { String(describing: Self.self) }
    
    // MARK: - Class Methods
    class func instanceFromNib() -> FeedItem? {
        UINib(nibName: nib, bundle: nil).instantiate(withOwner: nil, options: nil).first as? FeedItem
    }
    
    // MARK: - Stored Properties
    var delegate: ButtonDelegate?
    
    // MARK: - Custom Methods
    /// Configure view content based on the item given
    /// - Parameters:
    ///   - item: the item to configure content for
    ///   - showSale: if true show strikethrough old price if available
    func configureContent(with item: Item, showSale: Bool = false) {
        brandLabel.text = item.brand
        itemImageView.configure(with: item.pictures?.first)
        nameLabel.text = item.nameWithoutVendor
        oldPriceLabel.isHidden = !showSale
        priceLabel.text = item.price?.asPrice
        guard let oldPrice = item.oldPrice?.asPrice else { return }
        let attributedOldPrice = NSMutableAttributedString(string: oldPrice)
        attributedOldPrice.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributedOldPrice.length))
        oldPriceLabel.attributedText = attributedOldPrice
    }
    
    // MARK: - Actions
    @IBAction func likeButtonTapped(_ sender: DelegatedButton) {
        delegate?.buttonTapped(sender)
    }
    
}
