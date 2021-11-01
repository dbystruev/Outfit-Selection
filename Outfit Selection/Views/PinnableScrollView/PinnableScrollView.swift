//
//  PinnableScrollView.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 07/09/2019.
//  Copyright © 2019–2020 Denis Bystruev. All rights reserved.
//

import UIKit

class PinnableScrollView: UIScrollView {
    // MARK: - Stored Properties
    /// True if this scroll view is pinned, false otherwise
    private(set) var isPinned = false {
        didSet {
            alpha = isPinned ? 0.75 : unpinnedAlpha
        }
    }
    
    /// Ttime when offset was last changed
    private(set) var offsetChanged: Date?
    
    /// Alpha for unpinned state
    var unpinnedAlpha: CGFloat = 1 {
        didSet {
            if !isPinned {
                alpha = unpinnedAlpha
            }
        }
    }
    
    // MARK: - Computed Properties
    /// Repeats parent's content offset and updates time when offset was changed
    override var contentOffset: CGPoint {
        get { super.contentOffset }
        set {
            super.contentOffset = newValue
            offsetChanged = Date()
        }
    }
    
    /// Item which this scroll view is currently showing
    var item: Item? {
        getImageView()?.item
    }
    
    // MARK: - Methods
    /// Clear the border around the scroll view
    public func clearBorder() {
        layer.borderWidth = 0
    }
    
    /// Pin the scroll view — i.e. does not allow it to scroll during refresh
    public func pin() {
        isPinned = true
    }
    
    /// Restore the border around the scroll view
    public func restoreBorder() {
        layer.borderColor = tintColor.cgColor
        layer.borderWidth = isPinned ? 1 : 0
    }
    
    /// Toggle pin/unpin status
    public func togglePinned() {
        isPinned.toggle()
    }
    
    /// Unpin the scroll view — i.e. allow it to scroll during refresh
    public func unpin() {
        isPinned = false
    }
}
