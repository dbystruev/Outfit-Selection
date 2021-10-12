//
//  OnboardingViewController.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 12.10.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import UIKit

class OnboardingViewController: LoggingViewController {
    // MARK: - Outlets
    let nextButton = UIButton(frame: CGRect(x: 0, y: 0, width: 327, height: 56))
    
    /// Image view to display onboarding picture
    @IBOutlet weak var onboardingImageView: UIImageView!
    
    // MARK: - Static Properties
    /// True when we are going forwards
    static var goingForwards = false
    
    // MARK: - Custom Methods
    /// Configure content of this screen with given onboarding
    func configure() {
        // Get current onboarding
        let index = Onboarding.currentIndex
        let onboarding = Onboarding.all[index]
        
        // Configure with current onboarding
        onboardingImageView.image = onboarding.image
        title = onboarding.title
        
        // Configure popup with onboarding text
        let popup = storyboard?.instantiateViewController(
            withIdentifier: OnboardingPopupViewController.storyboardId
        )
        guard let onboardingPopup = popup as? OnboardingPopupViewController else {
            debug("ERROR: Can't cast", popup, "to \(OnboardingPopupViewController.self)")
            return
        }
        onboardingPopup.configure(with: onboarding.text)
        
        // MARK: DEBUG: TODO
        // Present onboarding popup
        // present(onboardingPopup, animated: true)
    }
    
    /// Set next button background color and enable it
    func configureNextButton() {
        // Don't add next button twice
        guard let navigationView = navigationController?.view else {
            debug("ERROR: Can't find navigation controller view")
            return
        }
        let button = navigationView.subviews.first(where: { $0 is UIButton })
        guard button == nil else { return }
        
        // Configure next button
        nextButton.addTarget(self, action: #selector(nextButtonTapped(_:)), for: .touchUpInside)
        nextButton.backgroundColor = Globals.Color.Button.enabled
        nextButton.layer.cornerRadius = 8
        nextButton.setTitle("Next", for: .normal)
        nextButton.setTitleColor(Globals.Color.Button.titleColor, for: .normal)
        nextButton.titleLabel?.font = Globals.Font.Onboarding.button
        
        // Add next button to navigation controller
        navigationView.addSubview(nextButton)
        
        // Setup constraints
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        let leading = nextButton.leadingAnchor.constraint(equalTo: navigationView.leadingAnchor, constant: 24)
        let optionalPriority = UILayoutPriority(750)
        let trailing = nextButton.trailingAnchor.constraint(equalTo: navigationView.trailingAnchor, constant: -24)
        [leading, trailing].forEach { $0.priority = optionalPriority }
        NSLayoutConstraint.activate([
            leading,
            nextButton.bottomAnchor.constraint(equalTo: navigationView.bottomAnchor, constant: -24),
            nextButton.centerXAnchor.constraint(equalTo: navigationView.centerXAnchor),
            nextButton.heightAnchor.constraint(equalToConstant: 56),
            nextButton.widthAnchor.constraint(lessThanOrEqualToConstant: 327),
            trailing
        ])
    }
    
    // MARK: - Inherited Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Show next button on top of navigation view once
        configureNextButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Show current onboarding
        configure()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Remove buttons from navigation controller if leaving onboarding
        let leavingBack = Onboarding.currentIndex == 0 && !OnboardingViewController.goingForwards
        let leavingForwards = Onboarding.currentIndex == Onboarding.all.count - 1 && OnboardingViewController.goingForwards
        if leavingBack || leavingForwards {
            navigationController?.view.subviews.reversed().filter({ $0 is UIButton }).forEach {
                $0.removeFromSuperview()
            }
        }
        
        // Increment or decrement onboarding current index by one depending on going forwards flag
        Onboarding.currentIndex += OnboardingViewController.goingForwards ? 1 : -1
        OnboardingViewController.goingForwards = false
    }
    
    // MARK: - Actions
    /// Called when next button is tapped
    /// - Parameter sender: the get outfit button which was tapped
    @objc func nextButtonTapped(_ sender: UIButton) {
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
