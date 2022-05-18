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

final class User: Codable {
    // MARK: - Public Properties
    /// Public properte current User
    static var current = User()
    
    // MARK: - Stored Properties
    /// Debug mode for current user
    var debugmode: Bool?
    /// Display name
    var displayName: String?
    /// User email
    var email: String?
    /// SHA512 string current email
    var emailHash: String?
    /// Gende for user
    var gender: String?
    /// The status is login
    var isLoggedIn: Bool?
    /// The number phone user
    var phone: String?
    /// Url profile photo
    var photoURL: String?
    /// The user's ID, unique to the Firebase project
    var uid: Int?
    
    // MARK: - Types
    enum CodingKeys: String, CodingKey {
        case debugmode
        case displayName = "name"
        case email
        case emailHash = "hash"
        case gender
        case isLoggedIn
        case phone
        case photoURL = "picture"
        case uid = "id"
    }
    
    // MARK: - Init
    /// Constructor for User
    /// - Parameters:
    ///   - debugmode: debug mode for current user
    ///   - displayName: display name
    ///   - email: user email
    ///   - emailHash: SHA512 string current email
    ///   - gender: gender
    ///   - isLoggedIn: the status is login
    ///   - phone: the phone number user
    ///   - photoURL: url profile photo
    ///   - uid: the user's ID, unique to the Firebase project
    init(
        debugmode: Bool? = false,
        displayName: String?  = nil,
        email: String?  = nil,
        emailHash: String? = nil,
        gender: String? = nil,
        isLoggedIn: Bool?  = nil,
        phone: String?  = nil,
        photoURL: String?  = nil,
        uid: Int? = nil
    ) {
        self.debugmode = debugmode
        self.displayName = displayName
        self.email = email
        self.emailHash = emailHash
        self.gender = gender
        self.isLoggedIn = isLoggedIn
        self.phone = phone
        self.photoURL = photoURL
        self.uid = uid
    }
    
    // MARK: - Methods
    /// Get SHA512 from String
    /// - Returns: SHA512 string current user, if iOS 13 or more and return nil if not
    func hash() -> String? {
        guard let email = User.current.email else { return nil }
        return email.isEmpty ? nil : User.hash(email)
    }
    
    /// Get SHA512 from String
    /// - Parameter email: String  email
    /// - Returns: SHA512 string, if iOS 13 or more and return nil if not
    static func hash(_ email: String) -> String? {
        let inputData = Data(email.lowercased().utf8)
        if #available(iOS 13.0, *) {
            let hashed = SHA512.hash(data: inputData)
            let hashString = hashed.compactMap { String(format: "%02x", $0) }.joined()
            return hashString
        } else {
            return nil
        }
    }
    
    /// Add new properties for found user if it need
    /// - Parameter user: user
    private func merge(newUser: User) {
        guard let userFound = Users.all.first(where: { $0.emailHash == emailHash  } ) else { return }
        userFound.emailHash = newUser.emailHash ?? userFound.emailHash
        userFound.displayName = newUser.displayName ?? userFound.displayName
        userFound.gender = newUser.gender ?? userFound.gender
        userFound.photoURL = newUser.photoURL ?? userFound.photoURL
        userFound.uid = newUser.uid ?? userFound.uid
    }
    
    /// Update currrent user
    /// - Parameters:
    ///   - debugmode: debug mode for current user
    ///   - displayName: display name
    ///   - email: user email
    ///   - isLoggedIn: the status is login
    ///   - phone: the phone number user
    ///   - photoURL: url profile photo
    ///   - uid: the user's ID, unique to the Firebase project
    static func update(
        debugmode: Bool?,
        displayName: String?,
        email: String,
        gender: String,
        isLoggedIn: Bool?,
        phone: String?,
        photoURL: String?,
        uid: Int?
    ){
        User.current.debugmode = debugmode ?? false
        User.current.displayName = displayName
        User.current.email = email
        User.current.isLoggedIn = isLoggedIn
        User.current.phone = phone
        User.current.photoURL = photoURL
        User.current.uid = uid
        
        // Get emailHash for current email
        guard let emailHash = User.hash(email) else { return }
        
        // Create new user
        let newUser = User(
            debugmode: debugmode,
            displayName: displayName,
            email: email,
            emailHash: emailHash,
            gender: gender,
            isLoggedIn: isLoggedIn,
            phone: phone,
            photoURL: photoURL,
            uid: uid
        )
        
        // Find current emailHash into Users.all
        if Users.all.first(where: { $0.emailHash == emailHash } ) == nil {
            Users.append(newUser)
        }
        
        // Update properties found user
        User.current.merge(newUser: newUser)
    }
    
}
