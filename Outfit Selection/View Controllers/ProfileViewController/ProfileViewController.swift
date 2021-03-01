//
//  ProfileViewController.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 28.02.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var profileCollectionView: UICollectionView!
    
    // MARK: - Stored Properties
    /// Brands view controller to use as profile collection view data source
    var brandsViewController: BrandsViewController?
    
    /// Gender to show in the collection view
    var shownGender: Gender?
    
    // MARK: - Inhertited Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Find and configure brands view controller
        brandsViewController = navigationController?.findViewController(ofType: BrandsViewController.self)
        
        // Setup profile collection view
        profileCollectionView.dataSource = self
        profileCollectionView.delegate = self
        profileCollectionView.register(BrandCell.nib, forCellWithReuseIdentifier: BrandCell.reuseId)
        profileCollectionView.register(GenderCell.nib, forCellWithReuseIdentifier: GenderCell.reuseId)
        profileCollectionView.register(ProfileSectionHeaderView.nib,
                                       forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                       withReuseIdentifier: ProfileSectionHeaderView.reuseId)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // If shown gender is different from current gender adjust it and reload gender section
        if shownGender != Gender.current {
            shownGender = Gender.current
            profileCollectionView.reloadSections([0])
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        profileCollectionView.reloadData()
    }
}
