//
//  AppDelegate.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 19/06/2019.
//  Copyright © 2019 Denis Bystruev. All rights reserved.
//

import UIKit

func debug(line: Int = #line,
           file: String = #file.lastComponent.dropExtension,
           function: String = #function,
           _ messages: CustomStringConvertible...) {
    let message = messages.reduce("") { "\($0) \($1)" }
    #if DEBUG
    print("\(line) \(file).\(function)\(message)")
    #endif
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        // For tests
        
        return true
    }
}

