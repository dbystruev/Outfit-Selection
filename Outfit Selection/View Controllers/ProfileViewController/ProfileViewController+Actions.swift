//
//  ProfileViewController+actions.swift
//  Outfit Selection
//
//  Created by Evgeniy Goncharov on 07.04.2022.
//  Copyright © 2022 Denis Bystruev. All rights reserved.
//

import Firebase

extension ProfileViewController {
    // MARK: - Helper Methods
    func logout() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            debug("Error signing out: %@", signOutError)
        }
        User.current.isLoggedIn = nil
        
        // Set default settiings UserDefaults
        UserDefaults.hasAnswerQuestions = false
        
        // Reload data from into profileCollectionView
        if AppDelegate.canReload && profileCollectionView?.hasUncommittedUpdates == false {
            profileCollectionView.reloadSections(IndexSet([0]))
        }
        
        // Check current user for debugmode
        if User.current.debugmode ?? false {
            
            // Set current user debug mode to false
            User.current.debugmode = false
            
            // Go to ProgressViewController for reload tabbarController
            guard let tabBarController = tabBarController as? TabBarController else { return }
            
            // Go to ProgressViewController for reload tabbarController
            tabBarController.popToProgress()
        }
    }
    
//    func showAlert() {
//        let alert = Alert.configured(
//            "Are you sure?"~,
//            message: "you will be logged out from account"~,
//            actionTitles: <#T##[String]#>,
//            styles: [.cancel, .destructive],
//            handlers: [{ _ in
//            },{ _ in
//            }])
//        present(alert, animated: true)
//    }
}

