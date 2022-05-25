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
    // MARK: - Inherited Methods
    /// Return navigation controller bar style back to normal
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.barStyle = .default
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Configue the views
        self.view.backgroundColor = Global.Color.Onboarding.background
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
                
                // Make shure the current auth user in not nil
                guard let user = authResult?.user else {
                    debug("ERROR: can't get authResult")
                    return
                }
                
                // Update current user
                User.update(
                    debugmode: false,
                    displayName: user.displayName,
                    email: user.email ?? "",
                    gender: Gender.current?.description ?? "",
                    isLoggedIn: true,
                    phone: user.phoneNumber,
                    photoURL: user.photoURL?.absoluteString,
                    uid: Int(user.uid)
                )
                
                // Get hash email curren user
                let currentEmailHash = User.hash(user.email ?? "")
                
                // Filter user where emailHash equals currentEmailHash
                let userContains = Users.all.first { $0.emailHash == currentEmailHash }
                
                // Get debugmode and it not equal false
                guard userContains?.debugmode == true else {
                    // Go to ProgressViewController for reload tabbarController
                    self.navigate(reload: true)
                    return
                }

                // Set current user ebugmode = true
                User.current.debugmode = true
                debug("INFO: Debug mode for \(String(describing: User.current.email)) ON")
                
                // Go to ProgressViewController for reload tabbarController
                self.navigate(reload: true)
            }
        }
    }
    
    // MARK: - Helper Methods
    private func navigate(reload progressViewController: Bool = false ) {
        
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
        
        // Check tabBarController
        if progressViewController {
            self.dismiss(animated: true)
            // Update all occasions with given gender
            Occasions.updateWith(gender: Gender.current)            
            tabBarController.popToProgress()
        }
        
        // Find navigationViewController into TabBarController
        guard let navigationController = tabBarController.viewControllers?.last as? UINavigationController else {
            debug("ERROR: Can't find UINavigationViewController into the", TabBarController.className)
            return
        }
        
        // Find TabBarController into navigationViewController
        guard let profileViewController = navigationController.findViewController(ofType: ProfileViewController.self) else {
            debug("ERROR: Can't find \(ProfileViewController.className) into the", ProfileViewController.className)
            return
        }
        
        // Reload data from into profileCollectionView
        if AppDelegate.canReload && profileViewController.profileCollectionView.hasUncommittedUpdates == false {
            profileViewController.profileCollectionView.reloadSections(IndexSet([0]))
        }
        self.dismiss(animated: true)
    }
}
