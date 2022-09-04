//
//  FeedsCollectionViewCell.swift
//  Outfit Selection
//
//  Created by Evgeniy Goncharov on 04.05.2022.
//  Copyright © 2022 Denis Bystruev. All rights reserved.
//

import UIKit

class FeedsCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var chevronImageView: UIImageView!
    @IBOutlet weak var feedNameLabel: UILabel!
    
    // MARK: - Methods
    /// Configure feed cell
    /// - Parameters:
    ///   - feed: the feed to confiture cell with
    ///   - hideChevron: true if chevron has to be hidden
    ///   - customLabel: nil by default. If not nil, use instead of feed.name
    func configure(
        with feed: Feed,
        hideChevron: Bool = true,
        customLabel: String? = nil) {
            logoImageView.configure(with: feed.picture)
            chevronImageView.isHidden = hideChevron
            feedNameLabel.text = customLabel ?? feed.name
        }
}
