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
    var doubleTapRecognizer: UITapGestureRecognizer!
    private(set) var isPinned = false
    var singleTapRecognizer: UITapGestureRecognizer!
    
    // MARK: - Computed Properties
    var item: Item? {
        itemIndex == nil || itemIndex! < 0 || Item.all.count <= itemIndex! ? nil : Item.all[itemIndex!]
    }
    
    var itemIndex: Int? {
        getImageView()?.tag
    }
    
    // MARK: - Methods
    public func clearBorder() {
        layer.borderWidth = 0
    }
    
    public func pin() {
        isPinned = true
    }
    
    public func restoreBorder() {
        layer.borderColor = tintColor.cgColor
        layer.borderWidth = isPinned ? 1 : 0
    }
    
    public func toggle() {
        isPinned.toggle()
    }
    
    public func unpin() {
        isPinned = false
    }
}
