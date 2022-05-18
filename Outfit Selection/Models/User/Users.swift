//
//  Users.swift
//  Outfit Selection
//
//  Created by Evgeniy Goncharov on 13.05.2022.
//  Copyright © 2022 Denis Bystruev. All rights reserved.
//

import Foundation

typealias Users = [User]

extension Users {
    // MARK: - Static Stored Properties
    /// All users as received from the server
    static var all: [User] = [
        User(debugmode: true,
             displayName: "Kim Sanzhiev",
             emailHash: "92889fd81e32986bf33400ece7df64d98a6e498950cb07bd48208ecd037d4c99709182c0ff8a8ddb6c13c5b0ee49f86ec99de50390de5155b3c70a0f079dc141",
             gender: "male",
             photoURL: "",
             uid: 1
            ),
        User(
            debugmode: true,
            displayName: "Tanya A",
            emailHash: "",
            gender: "female",
            photoURL: "https://acoolabox.com/images/tanya.jpg",
            uid: 2
        ),
        User(
            debugmode: true,
            displayName: "Denis Bystruev",
            emailHash: "22f94ed8521d6110b61b5dde07554aedef1cd7a5fe6f81e5189df9eb2d11c9a739487520d5c3672f095b8c26e350502f796f1580407cb81e2ca1e84cec20bc5a",
            gender: "male",
            photoURL: "https://acoolabox.com/images/tanya.jpg",
            uid: 3
        ),
        User(
            debugmode: true,
            displayName: "Sida Mirgamidova",
            emailHash: "",
            gender: "female",
            photoURL: "https://acoolabox.com/images/sida.jpg",
            uid: 4
        ),
        User(
            debugmode: true,
            displayName: "Mike Toropov",
            emailHash: "72a85a49f005b95544c87db838a1a6df55e9660d990e89a6cab13bf668e72dd47162ad9393f161669cc98cca0f62e5e5da4aec50e41a70b78c758f58a9afb71a",
            gender: "male",
            photoURL: "",
            uid: 5
        ),
        User(
            debugmode: true,
            displayName: "Evgeniy Goncharov",
            emailHash: "69a9740bb9aba104d130449f8f98b6b623099d98bcbfe249a1b2e9c02fc8185f10a220213675d67c7060cec618f51d55469d575cef90a86b4219780bbbe156fe",
            gender: "male",
            photoURL: "",
            uid: 6
        ),
    ]
    
    /// Users by hash
    private(set) static var byHash: [String: User] = [:]
    
    // MARK: - Static Methods
    /// Append given user to `byHash`
    /// - Parameter user: user for append
    static func append(_ user: User) {
        // Add new user
        all.append(user)
        // Make sure that the user has emailHash
        guard let hash = user.emailHash else { return }
        // Add user in to byHash
        byHash[hash] = user
    }
}
