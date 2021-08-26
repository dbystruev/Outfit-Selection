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
    @IBOutlet weak var shadows: UIView!
        
    // MARK: - Class Properties
    /// Nib name is the same as the class name
    class var nibName: String { String(describing: Self.self) }

    // MARK: - Static Properties
    static let designFactor = FeedItemCell.designFactor
    
    /// The nib object containing this feed item
    static let nib = UINib(nibName: nibName, bundle: nil)    
    
    // MARK: - Class Methods
    class func instanceFromNib() -> FeedItem? {
        let feedItem = nib.instantiate(withOwner: nil, options: nil).first as? FeedItem
        feedItem?.configureLayer()
        return feedItem
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
        
        // Set strikethrough red font for old price
        guard let oldPrice = item.oldPrice?.asPrice else { return }
        let attributedOldPrice = NSMutableAttributedString(string: oldPrice)
        attributedOldPrice.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributedOldPrice.length))
        oldPriceLabel.attributedText = attributedOldPrice
    }
    
    /// One-time layer configuration after estabishing instance
    func configureLayer() {
        // Don't add shadows for now
        // configureShadows()
    }
    
    /// One-time shadows configuraion after estabishing an instance
    // Code from Figma design at https://www.figma.com/file/RPuD2yffxN2n1K28h71dhj/GetOutfit?node-id=877%3A1502
    func configureShadows() {
        shadows.backgroundColor = .white
        shadows.clipsToBounds = false
        shadows.frame = CGRect(x: 0, y: 0, width: shadows.bounds.width * FeedItem.designFactor, height: shadows.bounds.height * FeedItem.designFactor)
        let shadowPath = UIBezierPath(roundedRect: shadows.bounds, cornerRadius: 8 * FeedItem.designFactor)
        let layer = CALayer()
        layer.backgroundColor = shadows.backgroundColor?.cgColor
        layer.shadowPath = shadowPath.cgPath
        layer.shadowColor = UIColor(red: 0.471, green: 0.537, blue: 0.518, alpha: 0.2).cgColor
        layer.shadowOpacity = 1
        layer.shadowRadius = 5 * FeedItem.designFactor
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.bounds = shadows.bounds
        layer.position = shadows.center
        shadows.layer.insertSublayer(layer, at: 0)
    }
    
    // MARK: - Actions
    @IBAction func likeButtonTapped(_ sender: DelegatedButton) {
        delegate?.buttonTapped(sender)
    }
    
}
