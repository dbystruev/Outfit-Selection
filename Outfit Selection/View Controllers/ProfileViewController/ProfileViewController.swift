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
    
    // MARK: - Stored Properties
    /// Brands view controller to use as profile collection view data source
    var brandsViewController: BrandsViewController?
    
    /// Gender to show in the collection view
    var shownGender: Gender?
    
    // MARK: - Inhertited Methods
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        profileCollectionView.collectionViewLayout.invalidateLayout()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Find and configure brands view controller
        brandsViewController = navigationController?.findViewController(ofType: BrandsViewController.self)
        
        // Configure navigation controller's bar font
        navigationController?.configureFont()
        
        // Setup profile collection view
        profileCollectionView.dataSource = self
        profileCollectionView.delegate = self
        profileCollectionView.register(BrandCollectionViewCell.nib, forCellWithReuseIdentifier: BrandCollectionViewCell.reuseId)
        profileCollectionView.register(GenderCollectionViewCell.nib, forCellWithReuseIdentifier: GenderCollectionViewCell.reuseId)
        profileCollectionView.register(ProfileSectionHeaderView.nib,
                                       forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                       withReuseIdentifier: ProfileSectionHeaderView.reuseId)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Make sure shown brands and gender match current brands and gender
        (tabBarController as? TabBarController)?.selectedBrands = BrandManager.shared.selectedBrands
        shownGender = Gender.current
        
        // Reload brand and gender data
        profileCollectionView.reloadData()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        profileCollectionView.reloadData()
    }
}
