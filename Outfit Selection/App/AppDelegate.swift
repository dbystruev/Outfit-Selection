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
    print("\(line) \(file).\(function)\(message)")
    #endif
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        // Change global tint color
        UIView.appearance().tintColor = #colorLiteral(red: 0.3157597482, green: 0.3807889521, blue: 0.3728570044, alpha: 1)
        
        // Ignore dark mode
        if #available(iOS 13.0, *) {
            window?.overrideUserInterfaceStyle = .light
        }
        
        // For tests
        
        return true
    }
}

