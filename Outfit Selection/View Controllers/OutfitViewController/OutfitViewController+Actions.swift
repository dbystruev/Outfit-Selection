//
//  ViewController+Actions.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 19/06/2019.
//  Copyright © 2019–2020 Denis Bystruev. All rights reserved.
//

import UIKit

// MARK: - Actions
extension OutfitViewController {
    @IBAction func addButtonTapped(sender: UIBarButtonItem) {
        unpin()
        selectedAction = isEditing ? .cancel : .add
        setEditing(!isEditing, animated: true)
    }
    
    @IBAction func bookmarksButtonTapped(_ sender: UIBarButtonItem) {
        selectedAction = isEditing ? .cancel : .bookmarks
        setEditing(!isEditing, animated: true)
    }
    
    @objc func brandButtonTapped(_ sender: UIBarButtonItem) {
        presentBrandsViewController()
    }
    
    @objc func priceButtonTapped(_ sender: UIBarButtonItem) {
        debug("Step 1:", sender.title)
        if sender.title == OutfitViewController.loadingMessage || sender.title == titleForCountButtonItem(assetCount) {
            debug("Step 2:", sender.title)
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                if sender.title == OutfitViewController.loadingMessage
                    || sender.title == self.titleForCountButtonItem(self.assetCount) {
                    debug("Step 3:", sender.title)
                    self.loadImages()
                }
            }
        }
    }
    
    @objc func diceButtonTapped(_ sender: UIBarButtonItem) {
        selectedAction = .cancel
        setEditing(false, animated: true)
        scrollViews.forEach {
            if !$0.isPinned {
                $0.scrollToRandomElement()
            }
        }
        
        updatePrice()
    }
    
    @IBAction func dislikeButtonTapped(_ sender: UIButton) {
        guard let scrollViewIndex = dislikeButtons.firstIndex(of: sender) else { return }
        
        // Cancel editing model
        setEditing(false, animated: false)
        
        selectedAction = .cancel
        
        guard scrollViewIndex < scrollViews.count else { return }
        let scrollView = scrollViews[scrollViewIndex]
        guard 1 < scrollView.count else { return }
        let indexToDelete = scrollView.currentIndex
        let deletingLastItem = indexToDelete == scrollView.count - 1
        let indexToShow = deletingLastItem ? indexToDelete - 1 : indexToDelete + 1
        
        scrollView.scrollToElement(withIndex: indexToShow) { completed in
            scrollView.deleteImageView(withIndex: indexToDelete)
            self.updateItemCount()
        }
    }
    
    @IBAction func genderItemTapped(_ sender: UIBarButtonItem) {
        presentGenderViewController()
    }
    
    @IBAction func greenPlusButtonTapped(_ sender: UIButton) {
        // Cancel editing mode
        setEditing(false, animated: false)
        
        // Continue only if we are in image adding mode
        guard selectedAction == .add else { return }
        
        selectedButtonIndex = greenPlusButtons.firstIndex(of: sender)
        
        selectedAction = .cancel
        
        let sourceTitles: [UIImagePickerController.SourceType: String] = [
            .camera: "📷",
            .photoLibrary: "🖼"
        ]
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        let cancel = UIAlertAction(title: "⛔️", style: .cancel)
        let alert = UIAlertController(title: "Image Source", message: nil, preferredStyle: .actionSheet)
        alert.addAction(cancel)
        
        for (source, title) in sourceTitles {
            guard UIImagePickerController.isSourceTypeAvailable(source) else { continue }
            let action = UIAlertAction(title: title, style: .default) { _ in
                imagePicker.sourceType = source
                self.present(imagePicker, animated: true)
            }
            alert.addAction(action)
        }
        
        //            let action = UIAlertAction(title: "👕", style: .default) { _ in
        //                self.performSegue(withIdentifier: "selectCategory", sender: nil)
        //            }
        //            alert.addAction(action)
        
        // Find negative constraint and make it positive
        for subview in alert.view.subviews {
            for constraint in subview.constraints {
                if constraint.constant < 0 {
                    constraint.constant = -constraint.constant
                }
            }
        }
        
        // Present alert controller
        present(alert, animated: true)
        
    }
    
    @IBAction func likeButtonTapped(_ sender: UIButton) {
        guard let selectedIndex = likeButtons.firstIndex(of: sender) else { return }
        
        let scrollView = scrollViews[selectedIndex]
        scrollView.toggle()
        
        likeButtons[selectedIndex].isSelected = scrollView.isPinned
        diceButtonItem.isEnabled = !scrollViews.allPinned
        
        updateButtons()
    }
    
    @IBAction func shareButtonTapped(_ sender: UIBarButtonItem) {
        setEditing(false, animated: true)
            
        let possibleScreenshot = getScreenshot(of: view)
        
        guard let screenshot = possibleScreenshot else { return }
        
        let activityController = UIActivityViewController(activityItems: [screenshot], applicationActivities: nil)
        activityController.popoverPresentationController?.sourceView = sender.customView
        present(activityController, animated: true)
    }
}
