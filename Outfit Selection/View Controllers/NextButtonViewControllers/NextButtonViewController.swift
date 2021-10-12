//
//  NextButtonViewController.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 12.10.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import UIKit

class NextButtonViewController: LoggingViewController {
    // MARK: - Outlets
    /// Next button at the bottom of the screen
    @IBOutlet weak var nextButton: UIButton!
    
    // MARK: - Custom Methods
    /// Set next button background color and enable / disable it
    /// - Parameter isEnabled: true if button should be enabled (default), false otherwise
    func configureNextButton(_ isEnabled: Bool = true) {
        nextButton.backgroundColor = isEnabled
            ? Globals.Color.Button.enabled
            : Globals.Color.Button.disabled
        nextButton.isEnabled = isEnabled
    }
    
    // MARK: - Inherited Methods
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNextButton()
    }
}
