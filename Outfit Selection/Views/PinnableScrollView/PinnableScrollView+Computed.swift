//
//  PinnableScrollView+Computed.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 16.11.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import UIKit

// MARK: - Computed Properties
extension PinnableScrollView {
    /// The number of item placeholders in the scroll view
    var count: Int {
        stackView?.arrangedSubviews.count ?? 0
    }
    
    /// Item which this scroll view is currently showing
    var item: Item? {
        getImageView()?.item
    }
    
    /// The number of items in the scroll view
    var itemCount: Int { items.count }
    
    /// Index of the current item in the scroll view
    var currentIndex: Int {
        guard 0 < elementWidth else { return 0 }
        return Int(round(contentOffset.x / elementWidth))
    }
    
    /// The width of elements in the scroll view
    var elementWidth: CGFloat {
        guard 0 < count else { return 0 }
        return contentSize.width / CGFloat(count)
    }
    
    /// Items in the scroll view
    var items: [Item] {
        stackView?.arrangedSubviews.compactMap { ($0 as? UIImageView)?.item } ?? []
    }
    
    /// Item IDs of each of the arranged subviews of the pinnable scroll view
    var itemIDs: [String] { items.IDs }
    
    /// Stack view which stores item images in the scroll view
    var stackView: UIStackView? {
        subviews.first as? UIStackView
    }
}
