//
//  ViewController+Gestures.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 19/06/2019.
//  Copyright © 2019 Denis Bystruev. All rights reserved.
//

import UIKit

// MARK: - Gestures
extension OutfitViewController {
    func setupTapGestureRecognizers() {
        scrollViews.forEach { scrollView in
            let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(scrollViewTapped(_:)))
            scrollView.addGestureRecognizer(tapRecognizer)
        }
    }
    
    @objc func scrollViewTapped(_ sender: UIGestureRecognizer) {
        guard let scrollView = sender.view as? UIScrollView else { return }
        scrollView.scrollToElement(withIndex: scrollView.currentIndex + 1)
    }
}
