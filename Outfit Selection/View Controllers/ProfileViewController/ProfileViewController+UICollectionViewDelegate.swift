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
        case 0:
            // Section 0 is gender — check if the user wants to change it
            let newGender = Gender.allCases[indexPath.row]
            guard let currentGender = Gender.current, newGender != shownGender else { return }
            if currentGender != newGender {
                let message = "Gender change will clear wishlists"
                let title = "Change to \(newGender.rawValue)"
                let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
                let cancel = UIAlertAction(title: "Don't", style: .cancel) { _ in
                    // Keep gender to current
                    self.shownGender = Gender.current
                    collectionView.reloadSections([0])
                }
                let ok = UIAlertAction(title: "Clear", style: .destructive) { _ in
                    // Reload gender section with new gender
                    self.shownGender = newGender
                    collectionView.reloadSections([0])
                }
                alert.addAction(ok)
                alert.addAction(cancel)
                present(alert, animated: true)
            } else {
                if newGender != shownGender {
                    shownGender = newGender
                    collectionView.reloadSections([0])
                }
            }
        case 1:
            // Section 1 is brands — reuse brands view controller to action
            brandsViewController?.collectionView(collectionView, didSelectItemAt: indexPath)
        default:
            debug("WARNING: Unknown section \(indexPath.section), row \(indexPath.row)")
        }
    }
}
