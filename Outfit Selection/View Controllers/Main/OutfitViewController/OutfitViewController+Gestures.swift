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
    // Configure single, double, and triple tap gestures
    func configureTapGestures() {
        scrollViews.forEach { scrollView in
            // Add single, double, and triple tap recognizers to each scroll view
            for tapsRequired in 1 ... 3 {
                let tapRecognizer = UITapGestureRecognizer(
                    target: self,
                    action: #selector(scrollViewTapped(_:))
                )
                tapRecognizer.delegate = scrollView
                tapRecognizer.numberOfTapsRequired = tapsRequired
                scrollView.addGestureRecognizer(tapRecognizer)
            }
            
            // Add long press recognizer to each scroll view
            let longPressRecognizer = UILongPressGestureRecognizer(
                target: self,
                action: #selector(pinImage(_:))
            )
            scrollView.addGestureRecognizer(longPressRecognizer)
        }
    }
    
    /// Hide SubcategoryLabels
    func closeSubcategoryLabels() {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(timeCloseSubcategoryLabels)) { [weak self] in
            self?.showSubcategoryLabels = false
        }
    }
    
    /// Called when double tap or long press gesture is recognized
    /// - Parameter sender: the object which recognized the gesture
    @objc func pinImage(_ sender: UIGestureRecognizer) {
        guard let scrollView = sender.view as? PinnableScrollView else { return }
        scrollView.togglePinned()
        shuffleButton.isEnabled = !scrollViews.allPinned
    }
    
    /// Called when scroll view is tapped one, two, or three times
    /// - Parameter sender: the gesture recognizer which recognized the taps
    @objc func scrollViewTapped(_ sender: UIGestureRecognizer) {
        
        // Make sure we were called from tap gesture recognizer
        guard let numberOfTaps = (sender as? UITapGestureRecognizer)?.numberOfTapsRequired else {
            debug("WARNING: \(sender) is not a \(UITapGestureRecognizer.self)")
            return
        }
        
        switch numberOfTaps {
            
        case 1:
            guard
                let scrollView = sender.view as? PinnableScrollView,
                let imageView = scrollView.getImageView(),
                imageView.displayedItem != nil
            else {
                debug("ERROR: Can't get an item from", sender.view)
                return
            }
            performSegue(withIdentifier: ItemViewController.segueIdentifier, sender: sender)
            
        case 2:
            // MARK: TODO Temporary Disabled
            // pinImage(sender)
            break
            
        case 3:
            toggleSubcategoryLabels()
            
            /// Close SubcategoryLabels after time timeCloseSubcategoryLabels
            closeSubcategoryLabels()
            
        default:
            debug("WARNING: Unknown number of taps: \(numberOfTaps)")
        }
    }
}
