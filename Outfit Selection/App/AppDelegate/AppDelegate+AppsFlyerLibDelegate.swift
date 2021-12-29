//
//  AppDelegate+AppsFlyerLibDelegate.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 09.03.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import AppsFlyerLib
import UIKit

extension AppDelegate: AppsFlyerLibDelegate {
    /// AppsFlyer Dev Key found in AppsFlyer.com dashboard > App Settings > DevKey
    static let appsFlyerDevKey = "..." // Replace with your AppsFlyer Dev Key
    
    /// AppsFlyer App ID found in AppsFlyer.com Dashboard > id in top left corner (without "id")
    static let appleAppID = "..." // Replace with your App ID
    
    /// Configures AppsFlyer developer key, app ID, App Tracking Transparency (ATT) support, and other settings
    /// - Parameter application: the singleton app object
    func appsFlyer(configureFor application: UIApplication) {
        guard checkAppsFlyer() else { return }
        
        AppsFlyerLib.shared().appsFlyerDevKey = AppDelegate.appsFlyerDevKey
        AppsFlyerLib.shared().appleAppID = AppDelegate.appleAppID
        AppsFlyerLib.shared().delegate = self
        AppsFlyerLib.shared().isDebug = false // true
    }
    
    /// Log deep links with OneLink
    /// - Parameters:
    ///   - userActivity: the activity object containing the data associated with the task the user was performing
    func appsFlyer(continue userActivity: NSUserActivity) {
        guard checkAppsFlyer() else { return }
        AppsFlyerLib.shared().continue(userActivity, restorationHandler: nil)
    }
    
    /// Enable AppsFlyer to handle push notification
    /// - Parameter userInfo: the `userInfo` from received remote notification. One of root keys should be "af"
    func appsFlyer(handlePushNotificationWith userInfo: [AnyHashable : Any]) {
        guard checkAppsFlyer() else { return }
        AppsFlyerLib.shared().handlePushNotification(userInfo)
    }
    
    /// Logs deep linking
    /// - Parameters:
    ///   - url: URL which was passed to the app delegate
    ///   - options: the options dictionary which was passed to the app delegate
    func appsFlyer(handleOpen url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) {
        guard checkAppsFlyer() else { return }
        AppsFlyerLib.shared().handleOpen(url, options: options)
    }
    
    /// Initializes AppsFlyer library
    func initAppsFlyer() {
        guard checkAppsFlyer() else { return }
        AppsFlyerLib.shared().start()
    }
    
    /// Checks if AppsFlyer appsFlyerDevKey and appleAppID are set
    /// - Parameters:
    ///   - line: current line, #line by default
    ///   - file: current file, #file by default
    ///   - function: current function, #function by default
    /// - Returns: true if appsFlyerDevKey and appleAppID are set, false otherwise
    func checkAppsFlyer(line: Int = #line, file: String = #file, function: String = #function) -> Bool {
        guard AppDelegate.appsFlyerDevKey.hasDigits && AppDelegate.appleAppID.hasDigits else {
//            debug(line: line, file: file, function: function, "WARNING: No appsFlyerDevKey and/or appleAppID is set")
            return false
        }
        
        return true
    }
    
    // MARK: - AppsFlyerLibDelegate
    // Handle Organic/Non-organic installation
    func onConversionDataSuccess(_ installData: [AnyHashable: Any]) {
        guard checkAppsFlyer() else { return }
        if let status = installData["af_status"] as? String {
            if (status == "Non-organic") {
                if let sourceID = installData["media_source"],
                   let campaign = installData["campaign"] {
                    debug("This is a Non-Organic install. Media source: \(sourceID)  Campaign: \(campaign)")
                }
            } else {
                debug("This is an organic install.")
            }
            if let is_first_launch = installData["is_first_launch"] as? Bool, is_first_launch {
                debug("First Launch")
            } else {
                debug("Not First Launch")
            }
        }
    }
    
    func onConversionDataFail(_ error: Error) {
        guard checkAppsFlyer() else { return }
        debug("\(error)")
    }
    
    // Handle Deep Link
    func onAppOpenAttribution(_ attributionData: [AnyHashable : Any]) {
        guard checkAppsFlyer() else { return }
        // Handle Deep Link Data
        debug("onAppOpenAttribution data:")
        for (key, value) in attributionData {
            debug("\(key): \(value)")
        }
    }
    
    func onAppOpenAttributionFailure(_ error: Error) {
        guard checkAppsFlyer() else { return }
        debug("\(error)")
    }
}
