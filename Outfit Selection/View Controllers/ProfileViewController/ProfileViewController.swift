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
    @IBOutlet weak var profileCollectionView: UICollectionView!
    @IBOutlet weak var versionLabel: UILabel!
    
    // MARK: - Stored Properties
    /// Brands view controller to use as profile collection view data source
    var brandsViewController: BrandsViewController?

    /// Height for cell
    let heightCell = 36
    
    /// Get current user is isLoggedIn
    var isLoggedIn = User.current.isLoggedIn
    
    /// Limit to showing items in section for brands and occasion
    let itemsLimit = 10
    
    /// Gender to show in the collection view
    var shownGender: Gender?
    
    /// Version and build number
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
    
    // MARK: - Inhertited Methods
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        profileCollectionView.collectionViewLayout.invalidateLayout()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Find and configure brands view controller
        brandsViewController = navigationController?.findViewController(ofType: BrandsViewController.self)
        
        // Configure version label with version and build
        configureVersionLabel()
        
        // Configure navigation controller's bar font
        navigationController?.configureFont()
    
        // Setup profile collection view
        profileCollectionView.dataSource = self
        profileCollectionView.delegate = self
        profileCollectionView.register(BrandCollectionViewCell.nib, forCellWithReuseIdentifier: BrandCollectionViewCell.reuseId)
        profileCollectionView.register(GenderCollectionViewCell.nib, forCellWithReuseIdentifier: GenderCollectionViewCell.reuseId)
        profileCollectionView.register(AccountCollectionViewCell.nib, forCellWithReuseIdentifier: AccountCollectionViewCell.reuseId)
        profileCollectionView.register(OccasionCollectionViewCell.nib, forCellWithReuseIdentifier: OccasionCollectionViewCell.reuseId)
        profileCollectionView.register(ProfileSectionHeaderView.nib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                       withReuseIdentifier: ProfileSectionHeaderView.reuseId)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Make sure shown brands and gender match current brands and gender
        (tabBarController as? TabBarController)?.selectedBrands = BrandManager.shared.selectedBrands
        shownGender = Gender.current
        
        // Reload brand and gender data
        profileCollectionView.reloadData()
        
        // Show tabbar 
        showTabBar()
        
        brandsViewController?.reloadData()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        profileCollectionView.reloadData()
    }
}
