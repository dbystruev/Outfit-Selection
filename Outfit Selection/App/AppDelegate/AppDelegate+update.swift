//
//  AppDelegate+update.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 23.09.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import Foundation

extension AppDelegate {
    // MARK: - Methods
    
    /// Update the list of barnds from the file and images
    static func updateBrands() {
        
        // Load barnds from file and append
        Brands.append(BrandManager.shared.brandedImages)
        Brands.append(BrandManager.shared.brandNamesFromFile)
        
        debug("INFO: loaded brands:", Brands.count, "| With image:", Brands.withImage.count)
    }
    
    /// Update the list of categories from the server
    static func updateCategories() {
        let startTime = Date()
        
        NetworkManager.shared.getCategories { categories in
            // Make sure we don't update to the empty list of categories
            guard let categories = categories, !categories.isEmpty else { return }
            
            // Update the categories
            Categories.all = categories
            let elapsedTime = Date().timeIntervalSince(startTime)
            debug("INFO: Loaded \(categories.count) categories in \(elapsedTime.asTime) s")
        }
    }
    
    /// Update the list of occasions from the server
    static func updateOccasions() {
        let startTime = Date()
        
        let nameNotification = Globals.Notification.name.updatedOccasions
        
        NetworkManager.shared.getOccasions { occasions in
            // Make sure we don't update to the empty list of occasions
            guard let occasions = occasions, !occasions.isEmpty else { return }
            
            // Fill occasions with the new list of occasions
            Occasions.removeAll()
            occasions.forEach { occasion in
                Occasions.append(occasion)
            }
            
            // Restore selected occasions from user defaults
            Occasions.restoreSelectedOccasions()
            
            // Show elapsed time
            let elapsedTime = Date().timeIntervalSince(startTime)

            debug(
                "INFO: Loaded \(Occasions.titles.count) / \(Occasions.count) occasions in \(elapsedTime.asTime) s,",
                "subcategories: \(Occasions.flatSubcategoryIDs.count),",
                "items: \(Occasions.flatItemIDs.count)"
            )
            
            // Post notification with name
            Globals.Notification.notificationCenter.post(
                name: Notification.Name(nameNotification),
                object: nil
            )
        }
    }
    
    /// Load onboarding screens
    /// - Parameter completion: a closure with bool parameter called in case of success (true) or failure (false)
    static func updateOnboarding(completion: @escaping (_ success: Bool) -> Void) {
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
            let elapsedTime = Date().timeIntervalSince(startTime)
            debug("INFO: Loaded \(Onboarding.all.count) onboarding screens in \(elapsedTime.asTime) s")
            
            completion(true)
        }
    }
}
