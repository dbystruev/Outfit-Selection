//
//  ViewController+UI.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 19/06/2019.
//  Copyright © 2019–2020 Denis Bystruev. All rights reserved.
//

import UIKit

// MARK: - UI
extension OutfitViewController {
    func configureGenderItem() {
        switch gender {
        case .female:
            genderItem.image = UIImage(named: "female_icon")
        case .male:
            genderItem.image = UIImage(named: "male_icon")
        default:
            genderItem.image = nil
        }
    }
    
    func getScreenshot(of view: UIView) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, true, 0)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        view.layer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    /// Load images for some items in Item.all filtered by category in Category.all.count into scroll views
    func loadImages() {
        // Clear scroll views
        scrollViews.clear()
        
        let startTime = Date()
        ItemManager.shared.loadImages(branded: brandNames, into: scrollViews) { itemsLoaded in
            let passedTime = Date().timeIntervalSince1970 - startTime.timeIntervalSince1970
            
            debug(itemsLoaded, "items are loaded into scroll views in", passedTime.asTime, "seconds")
            
            DispatchQueue.main.async {
                self.updateItemCount()
            }
        }
    }
    
    func pin() {
        scrollViews.pin()
        diceButtonItem.isEnabled = false
    }
    
    func setupToolbar() {
        countButtonItem = UIBarButtonItem(title: OutfitViewController.loadingMessage, style: .done, target: self,
                                          action: #selector(countButtonTapped(_:)))
        let deleteItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(trashButtonTapped(_:)))
        let diceImage = UIImage(named: "dice")
        diceButtonItem = UIBarButtonItem(image: diceImage, style: .plain, target: self, action: #selector(diceButtonTapped(_:)))
        let spaceItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbarItems = [countButtonItem, spaceItem, diceButtonItem!, spaceItem, deleteItem]
        navigationController?.setToolbarHidden(false, animated: false)
    }
    
    func setupUI() {
        buttonsStackView.isHidden = true
        
        pinButtons.forEach {
            if #available(iOS 13.0, *) {
                $0.imageView?.highlightedImage = UIImage(systemName: "pin.fill")
                $0.imageView?.image = UIImage(systemName: "pin")
            } else {
                $0.imageView?.highlightedImage = UIImage(named: "pin")
                $0.imageView?.image = UIImage(named: "pin")
            }
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
        
        setupToolbar()
    }
    
    func titleForCountButtonItem(_ items: Int) -> String {
        "Items: \(items)"
    }
    
    func unpin() {
        diceButtonItem.isEnabled = true
        pinButtons.forEach {
            $0.alpha = 0.5
            $0.imageView?.isHighlighted = false
        }
        scrollViews.unpin()
    }
    
    func updateButtons() {
        buttonsStackView.isHidden = ![.add, .trash].contains(selectedAction)
        buttons.forEach {
            $0.setEditing(action: selectedAction)
        }
    }
    
    func updateCountButtonItem(with count: Int) {
        countButtonItem.title = titleForCountButtonItem(count)
    }
    
    func updateItemCount() {
        updateCountButtonItem(with: itemCount)
        updatePrice()
    }
    
    func updatePrice() {
        guard let title = price?.asPrice else {
            updateCountButtonItem(with: itemCount)
            return
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.countButtonItem.title = title
        }
    }
}
