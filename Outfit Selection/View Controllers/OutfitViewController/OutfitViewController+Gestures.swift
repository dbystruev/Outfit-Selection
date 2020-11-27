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
    func setupGestures() {
        scrollViews.forEach { scrollView in
            let doubleTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(pinImage(_:)))
            doubleTapRecognizer.delegate = scrollView
            doubleTapRecognizer.numberOfTouchesRequired = 2
            scrollView.addGestureRecognizer(doubleTapRecognizer)
            
            let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(pinImage(_:)))
            scrollView.addGestureRecognizer(longPressRecognizer)
            
            let singleTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(scrollViewTappedOnce(_:)))
            singleTapRecognizer.delegate = scrollView
            scrollView.addGestureRecognizer(singleTapRecognizer)
            
            scrollView.doubleTapRecognizer = doubleTapRecognizer
            scrollView.singleTapRecognizer = singleTapRecognizer
        }
    }
    
    @objc func pinImage(_ sender: UIGestureRecognizer) {
        guard let scrollView = sender.view as? PinnableScrollView else { return }
        scrollView.toggle()
        diceButtonItem.isEnabled = !scrollViews.allPinned
    }
    
    @objc func scrollViewTappedOnce(_ sender: UIGestureRecognizer) {
        if sender.numberOfTouches == 1 {
            guard let scrollView = sender.view as? PinnableScrollView else { return }
            guard let imageView = scrollView.getImageView() else { return }
            guard imageView.image != nil && 0 <= imageView.tag else {
                debug("imageView.image =", imageView.image, "imageView.tag =", imageView.tag)
                return
            }
            performSegue(withIdentifier: "ItemViewController", sender: sender)
        } else {
            pinImage(sender)
        }
    }
}
