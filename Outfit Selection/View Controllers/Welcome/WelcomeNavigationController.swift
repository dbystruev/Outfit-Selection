//
//  WelcomeNavigationController.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 25.10.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import UIKit

class WelcomeNavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Remove onboarding view controllers if user has seen them
        if Onboarding.all.isEmpty || UserDefaults.hasSeenAppIntroduction {
            let onboardingScreens = navigationController?.viewControllers.filter { $0 is OnboardingViewController }
            onboardingScreens?.reversed().forEach { $0.removeFromParent() }
        }
    }
}
