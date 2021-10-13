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
        let index = Onboarding.currentIndex
        let onboarding = Onboarding.all[index]
        
        // Configure with current onboarding
        onboardingImageView.image = onboarding.image
        onboardingTextLabel.text = onboarding.text
        onboardingTitleLabel.text = onboarding.title
    }
    
    /// Configure onboarding stack view radius, background, and text colors
    func configureLayout() {
        // Hide navigation bar
        navigationController?.isNavigationBarHidden = true
        
        // Configue the views
        onboardingStackView.backgroundColor = Globals.Color.Onboarding.background
        onboardingStackView.layer.cornerRadius = 48
        onboardingTextLabel.textColor = Globals.Color.Onboarding.text
        onboardingTitleLabel.textColor = Globals.Color.Onboarding.text
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
    @IBAction func nextButtonTapped(_ sender: UIButton) {
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
        
        // Transition to occasions if they are not empty
        guard Occasion.all.isEmpty else {
            performSegue(withIdentifier: OccasionsViewController.segueIdentifier, sender: sender)
            return
        }
        
        // Transition to progress
        performSegue(withIdentifier: ProgressViewController.segueIdentifier, sender: sender)
    }
}
