//
//  PinnableScrollViews+Extension.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 07/09/2019.
//  Copyright © 2019 Denis Bystruev. All rights reserved.
//

typealias PinnableScrollViews = [PinnableScrollView]

extension PinnableScrollViews {
    var allPinned: Bool {
        return reduce(true) { $0 && $1.isPinned }
    }
    
    func clearBorders() {
        forEach { $0.clearBorder() }
    }
    
    func restoreBorders() {
        forEach { $0.restoreBorder() }
    }
}
