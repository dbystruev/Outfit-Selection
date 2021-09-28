//
//  FeedItemCollectionViewCell.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 27.08.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import UIKit

class FeedItemCollectionViewCell: UICollectionViewCell {
    // MARK: - Outlets
    var feedItem: FeedItem!
    
    // MARK: - Static Methods
    /// Returns the number of cells to fit in one row
    /// - Parameter size: size of a view to determine landscape or portrait orientation
    /// - Returns: the number of cells to fit in one row
    static func cellsPerRow(for size: CGSize) -> Int {
        // Fit 4 cells horizontally or 2 cells vertically
        size.height < size.width ? 4 : 2
    }
    
    // MARK: - Stored Properties
    /// Button delegate to send a message when something was tapped
    var delegate: ButtonDelegate? {
        didSet {
            feedItem.delegate = delegate
        }
    }
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureLayout()
    }
    
    // MARK: - Custom Methods
    /// Configure feed item content based on the item given
    /// - Parameters:
    ///   - kind: the type (kind) of item to configure content for
    ///   - item: item to configure feed item for
    ///   - isInteractive: allow clicks if true, don't if false
    func configureContent(kind: FeedKind, item: Item, isInteractive: Bool) {
        feedItem?.configureContent(with: item, showSale: kind == .sale, isInteractive: isInteractive)
    }
    
    /// Get feed item from xib and add it as subview of this cell
    func configureLayout() {
        // Obtain feed item from xib
        guard let feedItem = FeedItem.instanceFromNib() else {
            debug("Can't instantiate FeedItem from Nib")
            return
        }
        
        // Add feed item to content view
        self.feedItem = feedItem
        contentView.addSubview(feedItem)
        
        // Configure constraints
        feedItem.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            feedItem.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            feedItem.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            feedItem.topAnchor.constraint(equalTo: contentView.topAnchor),
            feedItem.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    /// Configure the view of feed item's like button depending on item being in wish list
    func configureLikeButton() {
        feedItem.configureLikeButton(isInteractive: true)
    }
}
