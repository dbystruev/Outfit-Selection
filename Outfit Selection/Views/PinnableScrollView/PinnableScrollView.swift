//
//  PinnableScrollView.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 07/09/2019.
//  Copyright © 2019 Denis Bystruev. All rights reserved.
//

import UIKit

class PinnableScrollView: UIScrollView {
    private(set) var isPinned = false {
        didSet {
            // restoreBorder()
        }
    }
    
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
