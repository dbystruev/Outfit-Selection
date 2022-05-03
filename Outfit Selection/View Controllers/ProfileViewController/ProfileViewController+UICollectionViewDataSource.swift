//
//  ProfileViewController+UICollectionViewDataSource.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 28.02.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import UIKit

// MARK: - UICollectionViewDataSource
extension ProfileViewController: UICollectionViewDataSource {
    // MARK: - Static Properties
    static let sectionHeaders = ["Account"~, "Gender"~, "Brands"~, "Occasions"~, "Feeds"~]
    
    // MARK: - UICollectionViewDataSource Methods
    /// Get cell for the given index path in profile collection view
    /// - Parameters:
    ///   - collectionView: profile collection view
    ///   - indexPath: index path to give the cell for
    /// - Returns: the cell for the given index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            // Check isLoggedIn
            guard User.current.isLoggedIn != nil else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AccountCollectionViewCell.reuseId, for: indexPath)
                (cell as? AccountCollectionViewCell)?.configure(titleLabel: "Log in"~, label: ""~, cursor: false)
                return cell
            }
            
            // Check the userCredentials for nil
            guard !User.current.userCredentials.isEmpty else { return UICollectionViewCell() }
            
            // Section 0 is account - configure user info cell
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AccountCollectionViewCell.reuseId, for: indexPath)
            let key = User.current.sequenceCredentials[indexPath.row]
            (cell as? AccountCollectionViewCell)?.configure(titleLabel: key,
                                                            label: User.current.userCredentials.first(where: { $0.key == key })?.value ?? "", cursor: false)
            
            return cell
        case 1:
            // Section 1 is gender - configure gender cell
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GenderCollectionViewCell.reuseId, for: indexPath)
            (cell as? GenderCollectionViewCell)?.configure(gender: Gender.allCases[indexPath.row], selected: shownGender)
            return cell
            
        case 2:
            // Section 2 is Occasion - configure occasion cell
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OccasionCollectionViewCell.reuseId, for: indexPath)
            
            // Configure one cell with simple text
            Occasions.selectedUniqueTitle.count > itemsLimit ?
            (cell as? OccasionCollectionViewCell)?.configure(
                with: Occasions.selectedUniqueTitle.sorted()[indexPath.row],
                hideCheckBox: true,
                hideChevron: false,
                custtomLabel: "Selected \(Occasions.selectedUniqueTitle.count) occasions out of \(Occasions.titles.count)"~ ) :
            (cell as? OccasionCollectionViewCell)?.configure(with: Occasions.selectedUniqueTitle.sorted()[indexPath.row])
            return cell
            
        case 3:
            // Section 3 is brands - use brands view controller section 0 to answer
            if Brands.selected.count > itemsLimit || Brands.selected.count == 0  {
                
                // Configure one cell with simple text
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OccasionCollectionViewCell.reuseId, for: indexPath)
                (cell as? OccasionCollectionViewCell)?.configure(
                    with: Occasions.selectedUniqueTitle.sorted()[indexPath.row],
                    hideCheckBox: true,
                    hideChevron: false,
                    custtomLabel: "Selected \(Brands.selected.count) brands out of \(Brands.count)"~ )
                return cell
                
            } else {
                // Return collectionViewCell with selected brands
                return brandsViewController?.collectionView(collectionView, cellForItemAt: indexPath) ?? BrandCollectionViewCell()
            }
        default:
            debug("WARNING: Unknown section \(indexPath.section), row \(indexPath.row)")
            return UICollectionViewCell()
        }
    }
    
    /// Configure and provide section header for the profile collection view
    /// - Parameters:
    ///   - collectionView: profile collection view
    ///   - kind: UICollectionView.elementKindSectionHeader
    ///   - indexPath: index path of given section
    /// - Returns: section header for the profile collection view
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ProfileSectionHeaderView.reuseId, for: indexPath)
            (headerView as? ProfileSectionHeaderView)?.configure(title: ProfileViewController.sectionHeaders[indexPath.section])
            return headerView
        default:
            debug("WARNING: Unknown kind \(kind) in section \(indexPath.section), row \(indexPath.row)")
            return UICollectionReusableView()
        }
    }
    
    /// Returns the number of items in each section of profile collection view
    /// - Parameters:
    ///   - collectionView: profile collection view
    ///   - section: section number to return the number of items for
    /// - Returns: the number of items in given section of profile collection view
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            // Section 0 is user info with avaliable properties
            return User.current.isLoggedIn != nil ? User.current.sequenceCredentials.count : 1
        case 1:
            // Section 1 is gender — 3 items
            return Gender.allCases.count
        case 2:
            // Section 2 is occasion — use occasion view controller section 0 to answer.
            return  Occasions.selectedUniqueTitle.count > itemsLimit ? 1 : Occasions.selectedUniqueTitle.count
            
        case 3:
            // Section 2 is brands — use brands view controller section 0 to answer.
            return Brands.selected.count > itemsLimit || Brands.selected.count == 0 ? 1 : Brands.selected.count
            
        default:
            debug("WARNING: Unknown section \(section)")
            return 0
        }
    }
    
    /// Returns the number of sections in profile collection view: 2 (gender and brands)
    /// - Parameter collectionView: profile collection view
    /// - Returns: the number of sections in profile collection view
    func numberOfSections(in collectionView: UICollectionView) -> Int { ProfileViewController.sectionHeaders.count }
}
