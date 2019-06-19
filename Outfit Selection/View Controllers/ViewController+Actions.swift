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
    @IBAction func shareButtonPressed(_ sender: UIBarButtonItem) {
        guard let view = navigationController?.view else { return }
        guard let image = makeScreenshot(of: view) else { return }
        let activityController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        activityController.popoverPresentationController?.sourceView = sender.customView
        present(activityController, animated: true)
    }
}
