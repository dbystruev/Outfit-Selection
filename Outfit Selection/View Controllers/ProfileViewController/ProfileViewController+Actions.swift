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
        
        // Reload data from into profileCollectionView
        profileCollectionView.reloadSections(IndexSet([0]))
    }
}
