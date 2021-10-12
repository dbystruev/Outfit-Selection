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
        Onboarding(image: placeholderImage, text: placeholderText, title: placeholderTitle),
        Onboarding(image: placeholderImage, text: placeholderText, title: placeholderTitle),
        Onboarding(image: placeholderImage, text: placeholderText, title: placeholderTitle)
    ]
    
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
    
    /// Onboarding placeholder title
    static let placeholderTitle = "An outfit for any occasion"
}
