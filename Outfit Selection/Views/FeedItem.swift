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
    
    // MARK: - Actions
    @IBAction func likeButtonTapped(_ sender: DelegatedButton) {
        delegate?.buttonTapped(sender)
    }
    
}
