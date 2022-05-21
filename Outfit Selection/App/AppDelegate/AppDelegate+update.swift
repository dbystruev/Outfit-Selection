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
        
        // Load images of brands from bundle
        Brands.append(BrandManager.shared.brandedImages)
        
        // Load and from file and append to the list of brands
        Brands.append(BrandManager.shared.brandNamesFromFile)
        
        debug(
            "INFO: Loaded: \(Brands.count) brands, with image", Brands.withImage.count
        )
    }
    
    /// Update the list of categories from the server
    /// - Parameter completion: closure called when request is finished, with true if request is succesfull, and false if not
    static func updateCategories(completion: @escaping (_ success: Bool) -> Void) {
        let startTime = Date()
        
        NetworkManager.shared.getCategories { categories in
            // Make sure we don't update to the empty list of categories
            guard let categories = categories, !categories.isEmpty else {
                completion(false)
                return
            }
            
            // Update the categories
            Categories.all = categories
            let elapsedTime = Date().timeIntervalSince(startTime)
            debug("INFO: Loaded \(categories.count) categories in \(elapsedTime.asTime) s")
            completion(true)
        }
    }
    
    /// Update the list of feeds from the server
    /// - Parameter completion: closure called when request is finished, with true if request is succesfull, and false if not
    static func updateFeeds(completion: @escaping (_ success: Bool) -> Void) {
        let startTime = Date()
        
        NetworkManager.shared.getFeeds { feeds in
            // Make sure we don't update to the empty list of feeds
            guard let feeds = feeds, !feeds.isEmpty else {
                completion(false)
                return
            }
            
            // Update the feeds
            FeedsProfile.all = feeds
            let elapsedTime = Date().timeIntervalSince(startTime)
            debug("INFO: Loaded \(feeds.count) feeds in \(elapsedTime.asTime) s")
            completion(true)
        }
    }
    
    /// Update the list of occasions from the server
    /// - Parameter completion: optional closure called when request is finished, with true if request is succesfull, and false if not
    static func updateOccasions(completion: ((_ success: Bool) -> Void)? = nil) {
        let startTime = Date()
        
        let nameNotification = Global.Notification.name.updatedOccasions
        
        NetworkManager.shared.getOccasions { occasions in
            // Make sure we don't update to the empty list of occasions
            guard let occasions = occasions, !occasions.isEmpty else {
                completion?(false)
                return
            }
            
            // Fill occasions with the new list of occasions
            Occasions.removeAll()
            
            occasions.forEach { occasion in
                Occasions.append(occasion)
            }
            
            // Show elapsed time
            let elapsedTime = Date().timeIntervalSince(startTime)
            
            debug(
                "INFO: Loaded \(Occasions.titles.count) / \(Occasions.count) occasions in \(elapsedTime.asTime) s,",
                "subcategories: \(Occasions.flatSubcategoryIDs.count),",
                "items: \(Occasions.flatItemIDs.count)"
            )
            
            // Restore selected occasions from user defaults
            Occasions.restoreSelectedOccasions()
            
            // Post notification with name
            Global.Notification.notificationCenter.post(
                name: Notification.Name(nameNotification),
                object: nil
            )
            
            // Complition
            completion?(true)
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
    
    /// Load debugMode users
    /// - Parameter completion: a closure with bool parameter called in case of success (true) or failure (false)
    static func updateUsers(completion: @escaping (_ success: Bool) -> Void) {
        let startTime = Date()
        NetworkManager.shared.getUsers { users in
            // Makr sure we don't update users with error values
            guard let users = users, !users.isEmpty else {
                completion(false)
                return
            }
            
            // Remove all users
            Users.all.removeAll()
            
            // Append new users
            for user in users { Users.append(user) }
            
            // Show elapsed time
            let elapsedTime = Date().timeIntervalSince(startTime)
            debug("INFO: Loaded \(Users.all.count) users with debugMode ON in \(elapsedTime.asTime) s")
            completion(true)
        }
        
    }
}
