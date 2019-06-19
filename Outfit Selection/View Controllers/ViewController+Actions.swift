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
    
    @IBAction func plusButtonPressed(_ sender: UIButton) {
        selectedButtonIndex = buttons.firstIndex(of: sender)
        let documentPicker = UIDocumentPickerViewController(documentTypes: ["public.image"], in: .import)
        documentPicker.allowsMultipleSelection = true
        documentPicker.delegate = self
        present(documentPicker, animated: true)
        setEditing(false, animated: false)
    }
    
    @objc func diceButtonPressed(_ sender: UIBarButtonItem) {
        setEditing(false, animated: true)
        scrollViews.forEach { $0.scrollToRandomElement() }
    }
}
