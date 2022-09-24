//
//  Onboarding.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 12.10.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import Foundation

struct Onboarding: Codable {
    // MARK: - Properties
    /// Onboarding image (displayed in the background)
    let image: URL
    
    /// Onboarding text (displayed in the popup)
    let text: String
    
    /// Onboarding title (displayed on top of popup)
    let title: String
}
