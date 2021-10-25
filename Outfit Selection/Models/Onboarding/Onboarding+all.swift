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
    static var all: [Onboarding] = []
    
    /// Index of current onboarding screen in all array
    static var currentIndex = 0 {
        didSet {
            // Make sure current index is between 0 and all.count - 1
            currentIndex = max(0, currentIndex)
            currentIndex = min(all.count - 1, currentIndex)
        }
    }
}
