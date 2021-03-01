//
//  AppDelegate.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 19/06/2019.
//  Copyright © 2019–2020 Denis Bystruev. All rights reserved.
//

import UIKit

func debug(line: Int = #line,
           file: String = #file,
           function: String = #function,
           _ messages: CustomStringConvertible?...) {
    let file = file.lastComponent.dropExtension
    let message = messages.reduce("") { "\($0) \($1?.description ?? "nil")" }
    #if DEBUG
    print("\(line) \(file).\(function)\(message.prefix(1024))")
    #endif
}

@UIApplicationMain
class AppDelegate: UIResponder {
    var window: UIWindow?
    
    // MARK: - Methods
    /// Update the list of categories from the server
    func updateCategories() {
        NetworkManager.shared.getCategories { categories in
            // Make sure we don't update to the empty list of categories
            guard let categories = categories, !categories.isEmpty else { return }
            
            Category.all = categories
        }
    }
}

// MARK: - UIApplicationDelegate
extension AppDelegate: UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        // Make sure we use the most recent URL
        NetworkManager.shared.updateURL() { _ in
            // Update the list of categories from the server
            self.updateCategories()
        }
        
        // Change global tint color
        UIView.appearance().tintColor = #colorLiteral(red: 0.4693212509, green: 0.5382487178, blue: 0.5183649659, alpha: 1)
        
        // Ignore dark mode
        if #available(iOS 13.0, *) {
            window?.overrideUserInterfaceStyle = .light
        }
        
        return true
    }
}
