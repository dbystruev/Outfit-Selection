//
//  PinnableScrollView.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 07/09/2019.
//  Copyright © 2019 Denis Bystruev. All rights reserved.
//

import UIKit

class PinnableScrollView: UIScrollView {
    var isPinned = false {
        didSet {
            restoreBorder()
        }
    }
    
    func clearBorder() {
        layer.borderWidth = 0
    }
    
    func restoreBorder() {
        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = isPinned ? 0.5 : 0
    }
}
