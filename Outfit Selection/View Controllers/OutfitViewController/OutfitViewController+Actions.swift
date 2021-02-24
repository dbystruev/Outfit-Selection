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
    @objc func brandButtonTapped(_ sender: UIBarButtonItem) {
        presentBrandsViewController()
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
    
    @IBAction func hangerBarButtonItemTapped(_ sender: UIBarButtonItem) {
        let shouldUnpin = scrollViews.allPinned
        diceButtonItem.isEnabled = shouldUnpin
        likeButtons.forEach { $0.isHidden = shouldUnpin }
        if shouldUnpin {
            scrollViews.unpin()
        } else {
            scrollViews.pin()
        }
    }
    
    @IBAction func hangerButtonTapped(_ sender: UIButton) {
        guard let selectedIndex = likeButtons.firstIndex(of: sender) else { return }
        
        let scrollView = scrollViews[selectedIndex]
        scrollView.toggle()
        
        likeButtons[selectedIndex].isHidden = !scrollView.isPinned
        diceButtonItem.isEnabled = !scrollViews.allPinned
    }
    
    @IBAction func shareButtonTapped(_ sender: UIBarButtonItem) {
        setEditing(false, animated: true)
        selectedAction = .cancel
        
        // Hide like buttons
        likeButtons.forEach { $0.isHidden = true }
        
        // Make screenshot
        let possibleScreenshot = getScreenshot(of: view)
        
        // Restore like buttons
        for (likeButton, scrollView) in zip(likeButtons, scrollViews) {
            likeButton.isHidden = !scrollView.isPinned
        }
        
        guard let screenshot = possibleScreenshot else { return }
        
        let activityController = UIActivityViewController(activityItems: [screenshot], applicationActivities: nil)
        activityController.popoverPresentationController?.sourceView = sender.customView
        present(activityController, animated: true)
    }
}
