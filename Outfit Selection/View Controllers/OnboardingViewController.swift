//
//  OnboardingViewController.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 12.10.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import UIKit

class OnboardingViewController: NextButtonViewController {
    // MARK: - Actions
    /// Called when next button is tapped
    /// - Parameter sender: the get outfit button which was tapped
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        // MARK: TODO: Transition to another onboarding screen if there are any remaining
//        guard Onboarding.all.isEmpty else {
//            performSegue(withIdentifier: OnboardingViewController.segueIdentifier, sender: sender)
//            return
//        }
        
        // Transition to occasions if they are not empty
        guard Occasion.all.isEmpty else {
            performSegue(withIdentifier: OccasionsViewController.segueIdentifier, sender: sender)
            return
        }
        
        // Transition to progress
        performSegue(withIdentifier: ProgressViewController.segueIdentifier, sender: sender)
    }
}
