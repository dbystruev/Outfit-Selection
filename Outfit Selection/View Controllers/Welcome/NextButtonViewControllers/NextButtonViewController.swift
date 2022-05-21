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
    @IBOutlet weak var nextButton: UIButton?
    
    /// Left swipe gesture recognizer for view
    let leftSwipeGesture = UISwipeGestureRecognizer()
    
    /// Right swipe gesture recognizer for view
    let rightSwipeGesture = UISwipeGestureRecognizer()
    
    // MARK: - Custom Methods
    /// Set next button background color and enable / disable it
    /// - Parameter isEnabled: true if button should be enabled (default), false otherwise
    func configureNextButton(_ isEnabled: Bool = true) {
        nextButton?.backgroundColor = isEnabled
            ? Global.Color.Button.enabled
            : Global.Color.Button.disabled
        nextButton?.isEnabled = isEnabled
    }
    
    // MARK: - Inherited Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Replace left swipe gesture recognizer default right direc tion to left
        leftSwipeGesture.direction = .left
        
        // Setup and add swipe recognizers to main view
        [leftSwipeGesture, rightSwipeGesture].forEach {
            $0.addTarget(self, action: #selector(swipeGestureRecognized(_:)))
            view.addGestureRecognizer($0)
        }
        
        // Add next button action
        nextButton?.addTarget(self, action: #selector(nextButtonTapped(_:)), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNextButton()
    }
    
    // MARK: - Actions
    /// Called when next button is tapped or right swipe gesture has been recognized and button is enab led
    /// - Parameter sender: the nexr button
    @objc dynamic func nextButtonTapped(_ sender: UIButton) {
        debug("WARNING: This action has to be overriden in child classes")
    }
    
    /// Called when left or right swift gesture recognizers are performed
    /// - Parameter sender: the gesture recognizer which has performed
    @objc func swipeGestureRecognized(_ sender: UISwipeGestureRecognizer) {
        // Make sure we only act when gestures are fully recognized
        guard sender.state == .recognized else { return }
        
        // Perform default actions on each gesture
        switch sender.direction {
            
        case .left:
            guard let nextButton = nextButton, nextButton.isEnabled else { return }
            nextButtonTapped(nextButton)
            
        case .right:
            navigationController?.popViewController(animated: true)
            
        default:
            debug("WARNING: Unknown gesture recognizer \(sender)")
        }
    }
}
