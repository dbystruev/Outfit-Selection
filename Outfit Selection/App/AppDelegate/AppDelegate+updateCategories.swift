//
//  AppDelegate+updateCategories.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 23.09.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import Foundation

extension AppDelegate {
    // MARK: - Methods
    /// Update the list of categories from the server
    func updateCategories() {
        let startTime = Date()
        
        NetworkManager.shared.getCategories { categories in
            // Make sure we don't update to the empty list of categories
            guard let categories = categories, !categories.isEmpty else { return }
            
            // Update the categories
            Categories.all = categories
            let elapsed = Date().timeIntervalSince(startTime)
            debug("INFO: Loaded \(categories.count) categories in \(elapsed.asTime) s")
        }
    }
    
    /// Update the list of occasions from the server
    func updateOccasions() {
        let startTime = Date()
        
        NetworkManager.shared.getOccasions { occasions in
            // Make sure we don't update to the empty list of occasions
            guard let occasions = occasions, !occasions.isEmpty else { return }
            
            // Fill occasions with the new list of occasions
            Occasion.all.removeAll()
            occasions.forEach { Occasion.all[$0.id] = $0 }
            
            // Restore additional occasions from user defaults
            Occasion.restore()
            
            // Show elapsed time
            let elapsed = Date().timeIntervalSince(startTime)
            debug("INFO: Loaded \(Occasion.all.count) occasions in \(elapsed.asTime) s")
        }
    }
    
    /// Load onboarding screens
    /// - Parameter completion: a closure with bool parameter called in case of success (true) or failure (false)
    func updateOnboarding(completion: @escaping (_ success: Bool) -> Void) {
        let startTime = Date()
        
        NetworkManager.shared.getOnboarding { onboardings in
            // Makr sure we don't update onboardings with error values
            guard let onboardings = onboardings else {
                completion(false)
                return
            }
            
            // Update onboardings
            Onboarding.all = onboardings
            Onboarding.currentIndex = 0
            
            // Show elapsed time
            let elapsed = Date().timeIntervalSince(startTime)
            debug("INFO: Loaded \(Onboarding.all.count) onboarding screens in \(elapsed.asTime) s")
            
            completion(true)
        }
    }
}
