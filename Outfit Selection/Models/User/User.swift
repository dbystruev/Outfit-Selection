//
//  User.swift
//  Outfit Selection
//
//  Created by Evgeniy Goncharov on 04.04.2022.
//  Copyright © 2022 Denis Bystruev. All rights reserved.
//

import FirebaseAuth
import UIKit

class User {
    // MARK: - Public Properties
    /// Public properte current User
    public var current: User?
    
    // MARK: - Stored Properties
    /// Display name
    let displayName: String?
    /// User email
    let email: String?
    /// The status is login
    let isLoggedIn: Bool?
    /// The number phone user
    let phone: String?
    /// Url profile photo
    let photoURL: URL?
    /// The user's ID, unique to the Firebase project
    let uid: String?
    
    // MARK: - Init
    /// Constructor for User
    /// - Parameters:
    ///   - isLoggedIn: The status is login
    init(
        displayName: String?  = nil,
        email: String?  = nil,
        isLoggedIn: Bool?  = nil,
        phone: String?  = nil,
        photoURL: URL?  = nil,
        uid: String? = nil
    ) {
        self.displayName = displayName
        self.email = email
        self.isLoggedIn = isLoggedIn
        self.phone = phone
        self.photoURL = photoURL
        self.uid = uid
    }
    
}

