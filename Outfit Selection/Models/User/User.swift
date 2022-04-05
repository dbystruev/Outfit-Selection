//
//  User.swift
//  Outfit Selection
//
//  Created by Evgeniy Goncharov on 04.04.2022.
//  Copyright © 2022 Denis Bystruev. All rights reserved.
//

import FirebaseAuth
import UIKit

final class User {
    // MARK: - Public Properties
    /// Public properte current User
    static let current = User()
    
    // MARK: - Stored Properties
    var dictionary: [String: String] = [:]
    /// Display name
    var displayName: String?
    /// User email
    var email: String?
    /// The status is login
    var isLoggedIn: Bool?
    /// The number phone user
    var phone: String?
    /// Url profile photo
    var photoURL: URL?
    /// The user's ID, unique to the Firebase project
    var uid: String?
    
    // MARK: - Init
    /// Constructor for User
    /// - Parameters:
    ///   - isLoggedIn: The status is login
    private init(
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
    
    // MARK: - Helper Methods
    func userInfo() {
        if User.current.displayName != nil {
            dictionary["Name"] = User.current.displayName
        } else if User.current.email != nil  {
            dictionary["Email"] = User.current.email
        } else if User.current.phone != nil {
            dictionary["Phone"] = User.current.email
        }
    }
}

