//
//  FeedsProfileCell.swift
//  Outfit Selection
//
//  Created by Evgeniy Goncharov on 04.05.2022.
//  Copyright © 2022 Denis Bystruev. All rights reserved.
//

import UIKit

class FeedsProfileCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet weak var checkBoxImageView: UIImageView!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var feedsNameLabel: UILabel!
    
    // MARK: - Static Constants
    static let heigth: CGFloat = UITableView.automaticDimension // 40
    
    // MARK: - Inherited Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        configureLayout()
    }

    // MARK: - Custom Methods
    /// Configures this cell with a given feed
    /// - Parameter feed: the feed to configure this cell with
    func configureContent(with feed: FeedProfile) {
        checkBoxImageView.isHighlighted = feed.shouldUse
        logoImageView.configure(with: feed.picture)
        feedsNameLabel.text = feed.name
    }
    
    /// Configure the cell's look and feel once at the beginning
    func configureLayout() {
        selectionStyle = .none
    }

}
