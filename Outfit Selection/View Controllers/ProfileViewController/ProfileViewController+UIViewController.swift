//
//  ProfileViewController+UIViewController.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 10.05.2022.
//  Copyright © 2022 Denis Bystruev. All rights reserved.
//

import UIKit

// MARK: - UIViewController
extension ProfileViewController {
    // MARK: - Helper Methods
    /// Configure user profile section
    private func configureUserCredentials() {
        userCredentials.updateValue(User.current.displayName ?? "", forKey: "Name:"~)
        userCredentials.updateValue(User.current.email ?? "", forKey: "Email:"~)
        userCredentials.updateValue(User.current.phone ?? "", forKey: "Phone:"~)
    }
    
    // MARK: - Inhertited Methods
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        profileCollectionView.collectionViewLayout.invalidateLayout()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Configure navigation controller's bar font
        navigationController?.configureFont()
    
        // Setup profile collection view
        profileCollectionView.dataSource = self
        profileCollectionView.delegate = self
        profileCollectionView.register(BrandCollectionViewCell.nib, forCellWithReuseIdentifier: BrandCollectionViewCell.reuseId)
        profileCollectionView.register(GenderCollectionViewCell.nib, forCellWithReuseIdentifier: GenderCollectionViewCell.reuseId)
        profileCollectionView.register(AccountCollectionViewCell.nib, forCellWithReuseIdentifier: AccountCollectionViewCell.reuseId)
        profileCollectionView.register(OccasionCollectionViewCell.nib, forCellWithReuseIdentifier: OccasionCollectionViewCell.reuseId)
        profileCollectionView.register(FeedsCollectionViewCell.nib, forCellWithReuseIdentifier: FeedsCollectionViewCell.reuseId)
        profileCollectionView.register(ProfileSectionHeaderView.nib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                       withReuseIdentifier: ProfileSectionHeaderView.reuseId)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // TODO: Move under profile quiz subsection
        NetworkManager.getQuiz(for: QuizGender(Gender.current)) { quiz in
            guard let quiz = quiz else { return }
            debug(quiz.records)
        }
        
        // Configure user profile section
        configureUserCredentials()
        
        // Make sure shown brands and gender match current brands and gender
        (tabBarController as? TabBarController)?.selectedBrands = BrandManager.shared.selectedBrands
        shownGender = Gender.current
        
        // Reload brand and gender data
        if AppDelegate.canReload && profileCollectionView?.hasUncommittedUpdates == false {
            profileCollectionView?.reloadData()
        }
        
        // Show Tabbar
        showTabBar()
        
        // Reload Data
        BrandsViewController.default?.reloadData()
        
        // Configure version label with version and build
        configureVersionLabel()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if AppDelegate.canReload && profileCollectionView?.hasUncommittedUpdates == false {
            profileCollectionView?.reloadData()
        }
    }
}
