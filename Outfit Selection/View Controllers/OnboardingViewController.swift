//
//  OnboardingViewController.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 12.10.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import UIKit

class OnboardingViewController: NextButtonViewController {
    // MARK: - Properties
    /// True when we are going forwards
    var goingForwards = false
    
    // MARK: - Inherited Methods
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let index = Onboarding.currentIndex
        title = "\(index + 1): \(Onboarding.all[index].title)"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Increment or decrement onboarding current index by one depending on going forwards flag
        Onboarding.currentIndex += goingForwards ? 1 : -1
        goingForwards = false
    }
    
    // MARK: - Actions
    /// Called when next button is tapped
    /// - Parameter sender: the get outfit button which was tapped
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        // Set going forwards flag to true when going forwards
        goingForwards = true
        
        // Transition to another onboarding screen if there are any remaining
        guard Onboarding.all.count <= Onboarding.currentIndex + 1 else {
            guard let nextPage = storyboard?.instantiateViewController(
                withIdentifier: OnboardingViewController.storyboardId
            ) else {
                debug("ERROR: Can't instantiate \(OnboardingViewController.storyboardId) from", storyboard)
                return
            }
            navigationController?.pushViewController(nextPage, animated: true)
            return
        }
        
        // Transition to occasions if they are not empty
        guard Occasion.all.isEmpty else {
            performSegue(withIdentifier: OccasionsViewController.segueIdentifier, sender: sender)
            return
        }
        
        // Transition to progress
        performSegue(withIdentifier: ProgressViewController.segueIdentifier, sender: sender)
    }
}
