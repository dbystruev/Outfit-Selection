//
//  Onboarding+all.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 12.10.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import UIKit

extension Onboarding {
    // MARK: - Static Constants
    /// All onboarding screens
    static let all: [Onboarding] = [
        Onboarding(
            image: placeholderImage,
            text: placeholderText,
            title: "We will find you a stylish look for any occasion"
        ),
        Onboarding(
            image: placeholderImage,
            text: placeholderText,
            title: "Collect your own wish list"
        ),
        Onboarding(
            image: placeholderImage,
            text: placeholderText,
            title: "Share clothing collections with your friends and followers"
        ),
    ]
    
    /// Index of current onboarding screen in all array
    static var currentIndex = 0 {
        didSet {
            // Make sure current index is between 0 and all.count - 1
            currentIndex = max(0, currentIndex)
            currentIndex = min(all.count - 1, currentIndex)
        }
    }
    
    /// Onboarding placeholder image
    static let placeholderImage = UIImage(named: "onboarding_placeholder")!
    
    /// Onboarding placeholder text
    static let placeholderText = """
        Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod
        tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam,
        quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo
        consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse
        cillum dolore
    """
}
