//
//  ViewController+Actions.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 19/06/2019.
//  Copyright © 2019 Denis Bystruev. All rights reserved.
//

import UIKit

// MARK: - Actions
extension OutfitViewController {
    @IBAction func addButtonPressed(sender: UIBarButtonItem) {
        unpin()
        selectedAction = isEditing ? .cancel : .add
        setEditing(!isEditing, animated: true)
    }
    
    @objc func diceButtonPressed(_ sender: UIBarButtonItem) {
        selectedAction = .cancel
        setEditing(false, animated: true)
        scrollViews.forEach {
            if !$0.isPinned {
                $0.scrollToRandomElement()
            }
        }
    }
    
    @IBAction func insideButtonPressed(_ sender: UIButton) {
        selectedButtonIndex = buttons.firstIndex(of: sender)
        setEditing(false, animated: false)
        
        switch selectedAction {
        
        case .add:
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
            
            let action = UIAlertAction(title: "👕", style: .default) { _ in
                self.performSegue(withIdentifier: "selectCategory", sender: nil)
            }
            alert.addAction(action)
            
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
            
        case .trash:
            selectedAction = .cancel
            
            guard let scrollViewIndex = selectedButtonIndex else { return }
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
            
        default:
            break
        }
        
    }
    
    @IBAction func pinButtonTapped(_ sender: UIButton) {
        guard let selectedIndex = pinButtons.firstIndex(of: sender) else { return }
        
        let scrollView = scrollViews[selectedIndex]
        scrollView.toggle()
        
        let isPinned = scrollView.isPinned
        let pinButton = pinButtons[selectedIndex]
        pinButton.alpha = isPinned ? 1 : 0.5
        pinButton.imageView?.isHighlighted = isPinned
        
        diceButtonItem.isEnabled = !scrollViews.allPinned
    }
    
    @IBAction func shareButtonPressed(_ sender: UIBarButtonItem) {
        setEditing(false, animated: true)
        guard let view = navigationController?.view else { return }
        
        pinButtons.forEach { $0.isHidden = true }
        let possibleScreenshot = getScreenshot(of: view)
        pinButtons.forEach { $0.isHidden = false }
        
        guard let screenshot = possibleScreenshot else { return }
        
        let activityController = UIActivityViewController(activityItems: [screenshot], applicationActivities: nil)
        activityController.popoverPresentationController?.sourceView = sender.customView
        present(activityController, animated: true)
    }
    
    @objc func trashButtonPressed(_ sender: UIBarButtonItem) {
        unpin()
        selectedAction = isEditing ? .cancel : .trash
        setEditing(!isEditing, animated: true)
        debug(isEditing)
    }
}
