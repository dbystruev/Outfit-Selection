//
//  ViewController+UI.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 19/06/2019.
//  Copyright © 2019 Denis Bystruev. All rights reserved.
//

import UIKit

// MARK: - UI
extension OutfitViewController {
    func getScreenshot(of view: UIView) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, true, 0)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        view.layer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    func pin() {
        scrollViews.pin()
        diceButtonItem.isEnabled = false
    }
    
    func setupUI() {
//        buttons.forEach {
//            $0.isHidden = !isEditing
//        }
        
        pinButtons.forEach {
            $0.imageView?.image = UIImage(systemName: "pin")
            $0.imageView?.highlightedImage = UIImage(systemName: "pin.fill")
        }
        
        scrollViews.forEach {
            $0.minimumZoomScale = zoomScale
            $0.maximumZoomScale = zoomScale
            $0.zoomScale = zoomScale
        }
        
        let logoImage = UIImage(named: "logo")
        let logoImageView = UIImageView(image: logoImage)
        logoImageView.contentMode = .scaleAspectFit
        navigationItem.titleView = logoImageView
        
        let deleteItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(trashButtonPressed(_:)))
        let spaceItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let diceImage = UIImage(named: "dice")
        diceButtonItem = UIBarButtonItem(image: diceImage, style: .plain, target: self, action: #selector(diceButtonPressed(_:)))
        
        setToolbarItems([deleteItem, spaceItem, countButtonItem, spaceItem, diceButtonItem], animated: false)
    }
    
    func unpin() {
        diceButtonItem.isEnabled = true
        pinButtons.forEach {
            $0.alpha = 0.5
            $0.imageView?.isHighlighted = false
        }
        scrollViews.unpin()
    }
    
    func updateItemCount() {
        let count = scrollViews.reduce(0) { $0 + $1.count }
        countButtonItem.title = "Items: \(count)"
    }
}
