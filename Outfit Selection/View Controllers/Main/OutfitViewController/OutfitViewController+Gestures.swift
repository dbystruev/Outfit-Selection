//
//  ViewController+Gestures.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 19/06/2019.
//  Copyright © 2019–2020 Denis Bystruev. All rights reserved.
//

import UIKit

// MARK: - Gestures
extension OutfitViewController {
    // Configure tap, double tap, and long press gestures
    func configureTapGestures() {
        scrollViews.forEach { scrollView in
            let tripleTapRecognizer = UITapGestureRecognizer(
                target: self,
                action: #selector(scrollViewTapped(_:))
            )
            tripleTapRecognizer.delegate = scrollView
            tripleTapRecognizer.numberOfTapsRequired = 3
            scrollView.addGestureRecognizer(tripleTapRecognizer)
            
            let doubleTapRecognizer = UITapGestureRecognizer(
                target: self,
                action: #selector(scrollViewTapped(_:))
            )
            doubleTapRecognizer.delegate = scrollView
            doubleTapRecognizer.numberOfTapsRequired = 2
            scrollView.addGestureRecognizer(doubleTapRecognizer)
            
//            let longPressRecognizer = UILongPressGestureRecognizer(
//                target: self,
//                action: #selector(pinImage(_:))
//            )
//            scrollView.addGestureRecognizer(longPressRecognizer)
            
            let singleTapRecognizer = UITapGestureRecognizer(
                target: self,
                action: #selector(scrollViewTapped(_:))
            )
            singleTapRecognizer.delegate = scrollView
            scrollView.addGestureRecognizer(singleTapRecognizer)
        }
    }
    
    @objc func pinImage(_ sender: UIGestureRecognizer) {
        guard let scrollView = sender.view as? PinnableScrollView else { return }
        scrollView.toggle()
        shuffleButton.isEnabled = !scrollViews.allPinned
    }
    
    /// Called when scroll view is tapped one, two, or three times
    /// - Parameter sender: the gesture recognizer which recognized the taps
    @objc func scrollViewTapped(_ sender: UIGestureRecognizer) {
        
        guard let taps = (sender as? UITapGestureRecognizer)?.numberOfTapsRequired else {
            debug("WARNING: \(sender) is not a \(UITapGestureRecognizer.self)")
            return
        }
        
        switch taps {
            
        case 1:
            guard let scrollView = sender.view as? PinnableScrollView else { return }
            guard let imageView = scrollView.getImageView() else { return }
            guard imageView.item != nil else {
                debug("ERROR: Can't get an item from \(imageView)")
                return
            }
            performSegue(withIdentifier: ItemViewController.segueIdentifier, sender: sender)
            
        case 2:
            pinImage(sender)
            
        case 3:
            showLookDetails()
            
        default:
            debug("WARNING: Unknown number of taps \(taps)")
        }
    }
}
