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
                
                // Find UINavigationViewController into presentingViewController
                guard let navigationController = self.presentingViewController as? UINavigationController else {
                    debug("ERROR: Can't find navigationController from the presentingViewController")
                    return
                }
                
                // Find TabBarController into navigationViewController
                guard let tabBarController = navigationController.findViewController(ofType: TabBarController.self) else {
                    debug("ERROR: Can't find \(TabBarController.className) into the UINavigationViewController")
                    return
                }
                
                // Find navigationViewController into TabBarController
                guard let navigationController = tabBarController.viewControllers?[Globals.TabBar.index.profile] as? UINavigationController else {
                    debug("ERROR: Can't find UINavigationViewController into the", TabBarController.className)
                    return
                }
                
                // Find TabBarController into navigationViewController
                guard let profileViewController = navigationController.findViewController(ofType: ProfileViewController.self) else {
                    debug("ERROR: Can't find \(ProfileViewController.className) into the", ProfileViewController.className)
                    return
                }
                
                // Reload data from into profileCollectionView
                profileViewController.profileCollectionView.reloadSections(IndexSet([0]))
                self.dismiss(animated: true)
            }
        }
    }
    
}
