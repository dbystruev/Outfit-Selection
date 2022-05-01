//
//  AppDelegate+UIApplicationDelegate.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 09.03.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//
import GoogleSignIn
import UIKit

// MARK: - UIApplicationDelegate
extension AppDelegate: UIApplicationDelegate {
    /// Called when the data for continuing an activity is available
    /// - Parameters:
    ///   - application: the shared app object that controls and coordinates this app
    ///   - userActivity: the activity object containing the data associated with the task the user was performing
    ///   - restorationHandler: a block to execute if the app creates objects to perform the task
    /// - Returns: true to indicate that the app handled the activity
    func application(_ application: UIApplication,
                     continue userActivity: NSUserActivity,
                     restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        
        self.userActivity = userActivity
        
        // Log deep links with OneLink
        appsFlyer(continue: userActivity)

        // Calling when app loaded and check universal link
        if loaded {
            checkUniversalLink(continue: userActivity)
        }
        
        return true
    }
    
    /// Called when the launch process is almost done and the app is almost ready to run
    /// - Parameters:
    ///   - application: the singleton app object
    ///   - launchOptions: a dictionary indicating the reason the app was launched (if any), may be empty when the user launched the app directly
    /// - Returns: true if a URL should be handled, system combines it with application(_:willFinishLaunchingWithOptions:)
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        // Dispatch group to delay launch until initial API calls are finished
        let group = DispatchGroup()
        group.enter()
        
        // Make sure we use the most recent URL
        NetworkManager.shared.updateURL() { _ in
            // Load onboarding screens if the user has not seen them yet
            if !UserDefaults.hasSeenAppIntroduction {
                AppDelegate.updateOnboarding { _ in group.leave() }
            } else {
                group.leave()
            }
            
            // Update the list of categories from the server
            AppDelegate.updateCategories()
        }
        
        // Initialize the window
        window = UIWindow(frame: UIScreen.main.bounds)
        let storyboard = UIStoryboard(name: "Welcome", bundle: nil)
        
        // Firebase configure
        AppDelegate.firebaseConfigure()
        
        // Load all brands 
        AppDelegate.updateBrands()
    
        // Change global tint color
        UIView.appearance().tintColor = #colorLiteral(red: 0.4693212509, green: 0.5382487178, blue: 0.5183649659, alpha: 1)
        
        // Ignore dark mode
        if #available(iOS 13.0, *) {
            window?.overrideUserInterfaceStyle = .light
        }
        
        // Temporary directory for a cache
        let temporaryDirectory = NSTemporaryDirectory()
        
        // Create a cache using 25 megabytes of memory and 50 megabytes of disk
        URLCache.shared = URLCache(
            memoryCapacity: 25_000_000,
            diskCapacity: 50_000_000,
            diskPath: temporaryDirectory
        )
        
        // Configure AppsFlyer
        appsFlyer(configureFor: application)
        
        // Configure current notification center
        userNotificationCenter(configureFor: application)

        // Restore settings from user defaults
        restoreSettings()
        
        // Wait for API requests to finish, but no more than 5 seconds
        _ = group.wait(timeout: .now() + 5)
        
        // Update the list of occasions from the server
        AppDelegate.updateOccasions()
        
        // Test occasion items if `should test` is true
        if shouldTest {
            // testAllOccasionItems()
            NetworkManager.shared.getOccasions { [weak self] occasions in
                // Check for self availability
                guard let self = self else {
                    debug("ERROR: self is not available")
                    return
                }
                
                guard let occasions = occasions else {
                    debug("ERROR: Can't get occasions")
                    return
                }
                
                let group = DispatchGroup()
                var result = true

                for occasion in occasions {
                    group.enter()
                    self.testOccasion(occasion.id) { testResult in
                        if !testResult {
                            debug("DEBUG: Occasion \(occasion) has not passed")
                        }
                        result = result && testResult
                        group.leave()
                    }
                }
                
                group.notify(queue: .global(qos: .background)) {
                    debug("DEBUG: \(occasions.count) occasions \(result ? "": "NOT ")passed")
                }
            }
        }
        
        // Don't show onboarding screens if the user has seen them or there are none
        let next = UserDefaults.hasSeenAppIntroduction || Onboarding.count < 1
        ? "GenderNavigationViewController"  // there are no classes to use .className
        : "OnboardingNavigationViewController"
        
        // Transfer to the initial view controller
        window?.rootViewController = storyboard.instantiateViewController(withIdentifier: next)
        window?.makeKeyAndVisible()
        
        return true
    }
    
    /// Called when a remote notification arrived that indicates there is data to be fetched
    /// - Parameters:wait
    ///   - application: the singleton app object
    ///   - userInfo: a dictionary with a badge number for the app icon, an alert sound, an alert message , a notification identifier, etc.
    ///   - completionHandler: the block to execute when the download operation is complete
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable : Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if userInfo["af"] != nil {
            // Enables AppsFlyer to handle push notification
            appsFlyer(handlePushNotificationWith: userInfo)
        }
    }
    
    /// Opens a resource specified by a URL
    /// - Parameters:
    ///   - app: the singleton app object
    ///   - url: the URL to open, including a network resource or a file
    ///   - options: a dictionary of URL handling options, empty by default
    /// - Returns: true to indicate the successful handling of the request
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        // Handle deep linking with AppsFlyer
        appsFlyer(handleOpen: url, options: options)
        
        // Handle deep linking with GoogleSignIn
        gIDSignIn(handleOpen: url, options: options)
        return true
    }
    
    /// Called when the app has become active
    /// - Parameter application: the singleton app object
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Initializes AppsFlyer
        initAppsFlyer()
    }
}
