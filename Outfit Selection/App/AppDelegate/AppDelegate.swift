//
//  AppDelegate.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 19/06/2019.
//  Copyright © 2019–2020 Denis Bystruev. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder {
    // MARK: - Stored Static Properties
    /// True when collection and table views can be reloaded, false when in background
    public static var canReload = false
    
    // MARK: - Stored Instance Properties
    /// Call testOccasionItems()
    let shouldTest = false // true
    
    /// Main application window
    var window: UIWindow?
    
    ///  Mark for universal link check statr
    var loaded = false {
        didSet {
            if loaded && !oldValue {
                if let userActivity = userActivity {
                    checkUniversalLink(continue: userActivity)
                }
            }
        }
    }
    
}
