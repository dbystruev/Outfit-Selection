//
//  FeedCollectionViewController+Actions.swift
//  Outfit Selection
//
//  Created by Evgeniy Goncharov on 19.05.2022.
//  Copyright © 2022 Denis Bystruev. All rights reserved.
//

import Foundation

extension FeedCollectionViewController {
    // MARK: - Methods
    /// Called when selected brands was changed
    @objc func haveBrandsChanged() {
        debug("INFO: Brands will changed")
        // Make feed item cells reload
        setSection()
        // Reload data
        if AppDelegate.canReload && feedCollectionView?.hasUncommittedUpdates == false {
            feedCollectionView?.reloadData()
        }
    }
}
