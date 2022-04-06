//
//  SignupViewController.swift
//  Outfit Selection
//
//  Created by Evgeniy Goncharov on 06.04.2022.
//  Copyright © 2022 Denis Bystruev. All rights reserved.
//

import Firebase
import GoogleSignIn
import UIKit

class SignupViewController: LoggingViewController {
    
    // MARK: - Stored Properties
    /// The handler for the auth state listener, to allow cancelling later.
    private var handle: AuthStateDidChangeListenerHandle?
    
    /// Found ViewController
    var profileViewController = ProfileViewController()
    
    // MARK: - Inherited Methods
    /// Return navigation controller bar style back to normal
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Remove auth listener
        Auth.auth().removeStateDidChangeListener(handle!)
        navigationController?.navigationBar.barStyle = .default
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Configue the views
        self.view.backgroundColor = Globals.Color.Onboarding.background
        // Start auth listener
        handle = Auth.auth().addStateDidChangeListener { auth, user in
            debug("INFO: current user:", user?.displayName)
        }
        
        findViewController()
    }
    
    // MARK: - Private Methods
    /// Fund presented ViewController
    private func findViewController() {
        guard let navigationController = presentingViewController as? UINavigationController else {
            debug("ERROR: Can't find navigationController from the presentingViewController")
            return
        }
        
        guard let profileViewController = navigationController.findViewController(ofType: ProfileViewController.self) else {
            debug("ERROR: Can't find \(ProfileViewController.className) from the", ProfileViewController.className)
            return
        }
        self.profileViewController = profileViewController
    }
    
    // MARK: - Actions
    /// Called when close button is tapped
    @IBAction func closeButton(_ sender: UIButton) {
        dismiss(animated: true)
    }
    /// Called when the google button is tapped
    /// - Parameter sender: the gesture recognizer which was tapped
    @IBAction func signInButtonTap(_ sender: Any) {
        // Get clientID from Firebase
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            debug("ERROR: can't get clientID from FirebaseApp")
            return
        }
        
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        
        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(with: config, presenting: self) { user, error in
            if let error = error {
                debug("ERROR:", error.localizedDescription)
                return
            }
            
            // Check authentication and idToken
            guard let authentication = user?.authentication, let idToken = authentication.idToken else {
                debug("ERROR: can't get idToken")
                return
            }
            
            // Create credential for auth call into firebase
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: authentication.accessToken)
            
            // Firebase authentication call
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    debug("ERROR:", error.localizedDescription)
                }
                // Check authResult
                guard let authResult = authResult else {
                    debug("ERROR: can't get authResult")
                    return
                }
                
                // Update date for current user
                User.current.userCredentials.updateValue(authResult.user.displayName ?? "", forKey: "Name:")
                User.current.userCredentials.updateValue(authResult.user.email ?? "", forKey: "Email:")
                User.current.userCredentials.updateValue(authResult.user.phoneNumber ?? "", forKey: "Phone:")
            
                User.current.isLoggedIn = true
                User.current.photoURL = authResult.user.photoURL
                User.current.uid = authResult.user.uid
                debug("INFO: Welcome", User.current.displayName)
                
            }
            self.dismiss(animated: false)
        }
    }
}
