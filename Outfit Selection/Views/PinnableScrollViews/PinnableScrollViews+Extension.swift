//
//  PinnableScrollViews+Extension.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 07/09/2019.
//  Copyright © 2019–2020 Denis Bystruev. All rights reserved.
//

typealias PinnableScrollViews = [PinnableScrollView]

extension PinnableScrollViews {
    var allPinned: Bool {
        return reduce(true) { $0 && $1.isPinned }
    }
    
    func clear() {
        forEach { $0.clear() }
        
        // Clear the number of images loaded into scroll views
        ItemManager.shared.imagesLoaded = 0
    }
    
    func clearBorders() {
        forEach { $0.clearBorder() }
    }
    
    func pin() {
        forEach { $0.pin() }
    }
    
    func restoreBorders() {
        forEach { $0.restoreBorder() }
    }
    
    func unpin() {
        forEach { $0.unpin() }
    }
}
