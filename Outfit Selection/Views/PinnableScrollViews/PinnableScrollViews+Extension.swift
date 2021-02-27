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
    
    /// Scroll its views to the given tags
    /// - Parameter tags: the tags to scroll the scroll views to
    func scrollToElements(withTags tags: [Int?]) {
        for (scrollView, tag) in zip(self, tags) {
            guard let tag = tag else { continue }
            scrollView.scrollToElement(withTag: tag)
        }
    }
    
    func unpin() {
        forEach { $0.unpin() }
    }
}
