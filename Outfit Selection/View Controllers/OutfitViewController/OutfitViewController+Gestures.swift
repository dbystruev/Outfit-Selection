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
            let longPress = UILongPressGestureRecognizer(target: self, action: #selector(pinImage(_:)))
            scrollView.addGestureRecognizer(longPress)
            
            let singleTap = UITapGestureRecognizer(target: self, action: #selector(scrollViewTappedOnce(_:)))
            scrollView.addGestureRecognizer(singleTap)
        }
    }
    
    @objc func pinImage(_ sender: UIGestureRecognizer) {
        guard let scrollView = sender.view as? PinnableScrollView else { return }
        scrollView.toggle()
        diceButtonItem.isEnabled = !scrollViews.allPinned
    }
    
    @objc func scrollViewTappedTwice(_ sender: UIGestureRecognizer) {
        pinImage(sender)
    }
    
    @objc func scrollViewTappedOnce(_ sender: UIGestureRecognizer) {
        performSegue(withIdentifier: "viewItem", sender: sender)
    }
}
