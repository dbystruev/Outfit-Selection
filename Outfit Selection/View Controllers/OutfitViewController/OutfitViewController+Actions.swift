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
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        selectedAction = .add
        setEditing(!isEditing, animated: true)
        return
    }
    
    @IBAction func shareButtonPressed(_ sender: UIBarButtonItem) {
        setEditing(false, animated: true)
        guard let view = navigationController?.view else { return }
        guard let image = getScreenshot(of: view) else { return }
        let activityController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        activityController.popoverPresentationController?.sourceView = sender.customView
        present(activityController, animated: true)
    }
    
    @IBAction func insideButtonPressed(_ sender: UIButton) {
        selectedButtonIndex = buttons.firstIndex(of: sender)
        setEditing(false, animated: false)
        
        switch selectedAction {
            
        case .add:
            let documentPicker = UIDocumentPickerViewController(documentTypes: ["public.image"], in: .import)
            documentPicker.allowsMultipleSelection = true
            documentPicker.delegate = self
            present(documentPicker, animated: true)
            
        case .trash:
            guard let scrollViewIndex = selectedButtonIndex else { return }
            guard scrollViewIndex < scrollViews.count else { return }
            let scrollView = scrollViews[scrollViewIndex]
            guard 1 < scrollView.count else { return }
            let indexToDelete = scrollView.currentIndex
            let deletingLastItem = indexToDelete == scrollView.count - 1
            let indexToShow = deletingLastItem ? indexToDelete - 1 : indexToDelete + 1
            
            scrollView.scrollToElement(withIndex: indexToShow) { completed in
                scrollView.deleteImage(withIndex: indexToDelete)
            }
            
        default:
            break
        }

    }
    
    @objc func trashButtonPressed(_ sender: UIBarButtonItem) {
        selectedAction = .trash
        setEditing(!isEditing, animated: true)
        return
    }
    
    @objc func diceButtonPressed(_ sender: UIBarButtonItem) {
        setEditing(false, animated: true)
        scrollViews.forEach { $0.scrollToRandomElement() }
    }
}
