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
            alpha = isPinned ? 1 : unpinnedAlpha
            self.isScrollEnabled = !isPinned
        }
    }
    
    /// Used by scrollToElement(withIndex:duration:) not to interfere with scrolling
    var isScrolling = false
    
    /// Ttime when offset was last changed
    private(set) var offsetChanged: Date?
    
    /// The index last scrolled to
    var scrolledIndex = 0
    
    /// Alpha for unpinned state
    var unpinnedAlpha: CGFloat = 1 {
        didSet {
            if !isPinned {
                alpha = unpinnedAlpha
            }
        }
    }
    
    // MARK: - Inherited Properties
    /// Repeats parent's content offset and updates time when offset was changed
    override var contentOffset: CGPoint {
        get { super.contentOffset }
        set {
            super.contentOffset = newValue
            offsetChanged = Date()
        }
    }
    
    // MARK: - Methods requiring private access
    /// Pin the scroll view — i.e. does not allow it to scroll during refresh
    public func pin() {
        isPinned = true
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
