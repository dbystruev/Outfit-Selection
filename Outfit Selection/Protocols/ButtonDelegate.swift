//
//  ButtonDelegate.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 20.08.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

/// Protocol for delegated button
protocol ButtonDelegate {
    /// Called when button is pressed
    /// - Parameter sender: an object (usually a button) which was tapped
    func buttonTapped(_ sender: Any)
}
