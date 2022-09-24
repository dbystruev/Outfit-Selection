//
//  AppDelegate+Firebase.swift
//  Outfit Selection
//
//  Created by Evgeniy Goncharov on 04.04.2022.
//  Copyright © 2022 Denis Bystruev. All rights reserved.
//

import GoogleSignIn
import Firebase

extension AppDelegate {
    /// Firebase configure
    static func firebaseConfigure() {
        FirebaseApp.configure()
    }
    
    /// GIDSignIn
    /// - Parameters:
    ///   - url: URL which was passed to the app delegate
    ///   - options: the options dictionary which was passed to the app delegate
    func gIDSignIn(handleOpen url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) {
        GIDSignIn.sharedInstance.handle(url)
    }
}

