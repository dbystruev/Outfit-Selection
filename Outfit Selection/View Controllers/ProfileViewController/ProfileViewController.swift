//
//  ProfileViewController.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 28.02.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import UIKit

class ProfileViewController: LoggingViewController {
    // MARK: - Outlets
    /// Consist of all sections and items shown on the profile screen
    @IBOutlet weak var profileCollectionView: UICollectionView!
    
    /// Version label with e.g. `v0.9.3 build 2022.05.01 spb` in the bottom right corner which appears 3 seconds after the load
    @IBOutlet weak var versionLabel: UILabel!
    
    // MARK: - Stored Properties
    /// Brands view controller for one of the `profile collection view` sections
    var brandsViewController: BrandsViewController?
    
    /// True if current user is logged in, false or nil othewise
    var isLoggedIn = User.current.isLoggedIn
    
    /// Maximum number of brands or occasions to show inline, more than that will have `selected ... brands / occasions out of ...`
    let maxItemCount = 10
    
    /// The height of typical cell and header in `profile collection view`
    let profileCellHeight = 36
    
    /// Gender to show in the collection view
    var shownGender: Gender?
    
    /// Version and build number, when set `version label` is updated
    var version: String? {
        didSet {
            versionLabel?.text = version
            
            // Hide the version label
            versionLabel.alpha = 0
            
            // Don't show version label if nil
            guard version != nil else { return }
            
            // Make version label appear in 3 seconds
            UIView.animate(withDuration: 1, delay: 3, options: []) {
                self.versionLabel.alpha = 0.5
            }
        }
    }
}
