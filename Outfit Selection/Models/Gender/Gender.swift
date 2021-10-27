//
//  Gender.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 26.10.2020.
//  Copyright © 2020 Denis Bystruev. All rights reserved.
//

/// Gender selected by the user
enum Gender: String, Codable {
    // MARK: - Static Properties
    /// Currently selected gender
    static var current: Gender? {
        didSet {
            // Update occasions to current gender only
            Occasion.updateWith(gender: current)
            
            // Load new occasions if we are changing from non-nil gender
            if current != oldValue && oldValue != nil {
                AppDelegate.updateOccasions()
            }
        }
    }
    
    // MARK: - Cases
    case female
    case male
    case other = "unisex"
}

// MARK: - Case Iterable
extension Gender: CaseIterable {}
