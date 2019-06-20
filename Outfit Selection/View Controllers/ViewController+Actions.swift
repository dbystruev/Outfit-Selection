//
//  ViewController+Actions.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 19/06/2019.
//  Copyright © 2019 Denis Bystruev. All rights reserved.
//

import UIKit

// MARK: - Actions
extension ViewController {
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
        if sender.isSelected {
            guard let scrollViewIndex = selectedButtonIndex else { return }
            guard scrollViewIndex < scrollViews.count else { return }
            let scrollView = scrollViews[scrollViewIndex]
            scrollView.scrollToElement(withIndex: scrollView.currentIndex + 1, duration: 0.5)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                scrollView.deleteImage(withIndex: scrollView.currentIndex - 1)
                scrollView.scrollToElement(withIndex: scrollView.currentIndex - 1, duration: 0)
            }
        } else {
            let documentPicker = UIDocumentPickerViewController(documentTypes: ["public.image"], in: .import)
            documentPicker.allowsMultipleSelection = true
            documentPicker.delegate = self
            present(documentPicker, animated: true)
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
