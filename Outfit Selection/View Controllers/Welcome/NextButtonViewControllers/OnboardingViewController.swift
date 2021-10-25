//
//  OnboardingViewController.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 12.10.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import UIKit

class OnboardingViewController: NextButtonViewController {
    // MARK: - Outlets
    /// Image view to display onboarding picture
    @IBOutlet weak var onboardingImageView: UIImageView!
    
    /// Stack view which contains onboarding title, text, and progress view with dash and dots
    @IBOutlet weak var onboardingStackView: UIStackView!
    
    /// In onboarding stack view / text scroll view: text label
    @IBOutlet weak var onboardingTextLabel: UILabel!
    
    /// In onboarding stack view: text scroll view
    @IBOutlet weak var onboardingTextScrollView: UIScrollView!
    
    /// In onboarding stack view: title label
    @IBOutlet weak var onboardingTitleLabel: UILabel!
    
    /// Progress dash and dots indicator buttons
    @IBOutlet var progressButtons: [UIButton]!
    
    /// Width constraints for each progress indicator button
    @IBOutlet var progressWidthConstraints: [NSLayoutConstraint]!
    
    /// In onboarding stack view: progress stack view with dash and dots
    @IBOutlet weak var progressStackView: UIStackView!
    
    /// In onboarding space view: placeholder space for floating next button
    @IBOutlet weak var spaceView: UIView!
    
    // MARK: - Static Properties
    /// True when we are going forwards
    static var goingForwards = false
    
    // MARK: - Custom Methods
    /// Configure content of this screen with given onboarding
    func configureContent() {
        // Get current onboarding
        let currentIndex = Onboarding.currentIndex
        let onboarding = Onboarding.all[currentIndex]
        
        // Configure with current onboarding
        onboardingImageView.configure(with: onboarding.image)
        onboardingTextLabel.text = onboarding.text
        onboardingTitleLabel.text = onboarding.title
        
        // Configure progress indicator buttons
        for buttonIndex in 0 ..< min(progressButtons.count, progressWidthConstraints.count) {
            // Show dash when current onboarding is selected
            let isDash = currentIndex == buttonIndex
            
            // Set button background color
            progressButtons[buttonIndex].backgroundColor = isDash
                ? Globals.Color.Onboarding.dash
                : Globals.Color.Onboarding.dot
            
            // Set button width
            progressWidthConstraints[buttonIndex].constant = isDash ? 16 : 4
        }
    }
    
    /// Configure onboarding stack view radius, background, and text colors
    func configureLayout() {
        // Hide navigation bar
        navigationController?.isNavigationBarHidden = true
        
        // Configue the views
        onboardingStackView.backgroundColor = Globals.Color.Onboarding.background
        onboardingStackView.layer.cornerRadius = 16
        onboardingTextLabel.textColor = Globals.Color.Onboarding.text
        onboardingTitleLabel.textColor = Globals.Color.Onboarding.text
        
        // Configure progress indicators
        progressButtons.forEach { $0.layer.cornerRadius = 2 }
    }
    
    // MARK: - Inherited Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure onboarding stack view radius and colors
        configureLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Show current onboarding
        configureContent()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Increment or decrement onboarding current index by one depending on going forwards flag
        Onboarding.currentIndex += OnboardingViewController.goingForwards ? 1 : -1
        OnboardingViewController.goingForwards = false
    }
    
    // MARK: - Actions
    /// Called when next button is tapped
    /// - Parameter sender: the get outfit button which was tapped
    override func nextButtonTapped(_ sender: UIButton) {
        // Set going forwards flag to true when going forwards
        OnboardingViewController.goingForwards = true
        
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
        
        // Transition to progress
        UserDefaults.hasSeenAppIntroduction = true
        performSegue(withIdentifier: ProgressViewController.segueIdentifier, sender: sender)
    }
    
    /// Called when one of dash or dot progress buttons is tapped
    /// - Parameter sender: the dash or dot button which was tapped
    @IBAction func progressButtonTapped(_ sender: UIButton) {
        // Find the index of the progress button which was tapped
        guard let buttonIndex = progressButtons.firstIndex(of: sender) else {
            debug("WARNING: No", sender, "is found in", progressButtons)
            return
        }
        
        // Get onboarding index and don't act on current screen
        let currentIndex = Onboarding.currentIndex
        if buttonIndex < currentIndex {
            // Move backwards if tapped button is below current index
            navigationController?.popViewController(animated: true)
        } else if currentIndex < buttonIndex {
            // Move forwards if tapped button is above current index
            nextButtonTapped(sender)
        }
    }
}
