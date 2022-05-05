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
func configure(
    with feed: FeedProfile,
    hideChevron: Bool = true,
    custtomLabel: String = "") {
        logoImageView.configure(with: feed.picture)
        chevronImageView.isHidden = hideChevron
        feedNameLabel.text = custtomLabel.isEmpty ? feed.name : custtomLabel
    }
}
