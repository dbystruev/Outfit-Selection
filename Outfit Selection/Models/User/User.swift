//
//  User.swift
//  Outfit Selection
//
//  Created by Evgeniy Goncharov on 04.04.2022.
//  Copyright © 2022 Denis Bystruev. All rights reserved.
//

import CryptoKit
import FirebaseAuth
import UIKit

final class User {
    // MARK: - Public Properties
    /// Public properte current User
    static let current = User()
    
    // MARK: - Stored Properties
    /// Debug mode for current user
    var debugmode: Bool
    /// Display name
    var displayName: String?
    /// User email
    var email: String
    /// The status is login
    var isLoggedIn: Bool?
    /// The number phone user
    var phone: String?
    /// Url profile photo
    var photoURL: URL?
    
    //TODO: Move it to profileViewController
    /// Dictionary with user data
    var sequenceCredentials = ["Name:"~, "Email:"~, "Phone:"~, "Log out"~]
    /// The user's ID, unique to the Firebase project
    var uid: String?
    /// The array with user data ["Email":"example@apple.com"].
    var userCredentials = ["Name:"~: "", "Email:"~: "", "Phone:"~: "", "Log out"~: ""~ ]
    
    // MARK: - Init
    /// Constructor for User
    /// - Parameters:
    ///   - isLoggedIn: The status is login
    init(
        debugmode: Bool = false,
        displayName: String?  = nil,
        email: String  = "",
        isLoggedIn: Bool?  = nil,
        phone: String?  = nil,
        photoURL: URL?  = nil,
        uid: String? = nil
    ) {
        self.debugmode = debugmode
        self.displayName = displayName
        self.email = email
        self.isLoggedIn = isLoggedIn
        self.phone = phone
        self.photoURL = photoURL
        self.uid = uid
    }
    
    // MARK: - Methods
    /// Get SHA512 from String
    /// - Returns: SHA512 string current user, if iOS 13 or more and return nil if not
    func hash() -> String? {
        let email = User.current.email
        return email.isEmpty ? nil : hash(email)
    }
    
    /// Get SHA512 from String
    /// - Parameter email: String  email
    /// - Returns: SHA512 string, if iOS 13 or more and return nil if not
    func hash(_ email: String) -> String? {
        let inputData = Data(email.utf8)
        if #available(iOS 13.0, *) {
            let hashed = SHA512.hash(data: inputData)
            let hashString = hashed.compactMap { String(format: "%02x", $0) }.joined()
            return hashString
        } else {
            return nil
        }
    }
    
}
