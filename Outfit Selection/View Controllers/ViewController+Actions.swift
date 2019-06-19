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
    @IBAction func diceButtonPressed(_ sender: UIBarButtonItem) {
        scrollViews.forEach { $0.scrollToRandomElement() }
    }
    
    @IBAction func shareButtonPressed(_ sender: UIBarButtonItem) {
        guard let view = navigationController?.view else { return }
        guard let image = getScreenshot(of: view) else { return }
        let activityController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        activityController.popoverPresentationController?.sourceView = sender.customView
        present(activityController, animated: true)
    }
}
