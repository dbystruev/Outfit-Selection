//
//  ProfileViewController+UICollectionViewDelegate.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 28.02.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import UIKit

// MARK: - UICollectionViewDelegate
extension ProfileViewController: UICollectionViewDelegate {
    /// Perform an action when a user taps an item in the profile collection view
    /// - Parameters:
    ///   - collectionView: the profile collection view
    ///   - indexPath: item index path the user has tapped on
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        // Section 0 is account — log in / log out
        case Section.account.rawValue:
            //debug(indexPath.row, User.current.isLoggedIn, User.current.sequenceCredentials[indexPath.row])
            // logout current user
            if User.current.isLoggedIn != nil {
                if sequenceCredentials[indexPath.row] == "Log out"~ {
                    // Logout into current account
                    showAlert()
                }
            } else {
                // Instantiate the tab bar controller
                let mainStoryboard = UIStoryboard(name: "Signup", bundle: nil)
                let signupViewController = mainStoryboard.instantiateViewController(withIdentifier: "SignupViewController")
                navigationController?.showDetailViewController(signupViewController, sender: nil)
            }
        // Section 1 is gender — check if the user wants to change it
        case Section.gender.rawValue:
            let newGender = Gender.allCases[indexPath.row]
            guard let currentGender = Gender.current, newGender != shownGender else { return }
            if currentGender != newGender {
                present(Alert.genderChange(to: newGender, sender: self), animated: true)
            } else {
                if newGender != shownGender {
                    shownGender = newGender
                    if AppDelegate.canReload && collectionView.hasUncommittedUpdates == false {
                        collectionView.reloadSections([Section.gender.rawValue])
                    }
                }
            }
        // Section 2 is currency — toggle the switch
        case Section.currency.rawValue:
            UserDefaults.convertToAED.toggle()
            if AppDelegate.canReload && collectionView.hasUncommittedUpdates == false {
                collectionView.reloadSections([Section.currency.rawValue])
            }
            
        // Section 3 is brands — select brand and go to BrandsViewController for edit the brands list
        case Section.brands.rawValue:
            guard let brandsViewController = BrandsViewController.default else {
                debug("WARNING: BrandsViewController.default is nil")
                return
            }
            // Set isEditing true
            brandsViewController.setEditing(true, animated: true)
            // Load BrandsViewController
            self.navigationController?.show(brandsViewController, sender: nil)
        // Section 4 is occasions — select occasion and go to OccasionsViewController for edit the occasions list
        case Section.occasions.rawValue:
            let mainStoryboard = UIStoryboard(name: "Welcome", bundle: nil)
            let occasionsViewController = mainStoryboard.instantiateViewController(withIdentifier: "OccasionsViewController")
            // Set isEditing true
            occasionsViewController.setEditing(true, animated: true)
            // Load OccasionsViewController
            self.navigationController?.show(occasionsViewController, sender: nil)
        // Section 5 is feeds — select feed and go to FeedsProfileViewController for edit the feeds list
        case Section.feeds.rawValue:
            self.performSegue(withIdentifier: FeedsProfileViewController.segueIdentifier, sender: nil)
        default:
            debug("WARNING: Unknown section \(indexPath.section), row \(indexPath.row)")
        }
    }
    
}
