//
//  ProfileViewController+UICollectionViewDataSource.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 28.02.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import UIKit
import CryptoKit

// MARK: - UICollectionViewDataSource
extension ProfileViewController: UICollectionViewDataSource {
    // MARK: - Static Properties
    private static let sectionHeaders = ["Account"~, "Gender"~, "Brands"~, "Occasions"~, "Feeds"~]
    
    // MARK: - UICollectionViewDataSource Methods
    /// Get cell for the given index path in profile collection view
    /// - Parameters:
    ///   - collectionView: profile collection view
    ///   - indexPath: index path to give the cell for
    /// - Returns: the cell for the given index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            // Section 0 is account credentials - configure account cell
            let cell = collectionView
                .dequeueReusableCell(withReuseIdentifier: AccountCollectionViewCell.reuseId, for: indexPath)
            let accountCell = cell as? AccountCollectionViewCell
            // If user is not logged in show "Log in" prompt
            guard hasAccountCredentials else {
                accountCell?.configure("Log in"~)
                return cell
            }
            let key = sequenceCredentials[indexPath.row] // Name, Email, Phone, ...
            let credential = userCredentials.first(where: { $0.key == key })?.value ?? ""
            accountCell?.configure(key, text: credential)
            return cell
        case 1:
            // Section 1 is gender - configure gender cell
            let cell = collectionView
                .dequeueReusableCell(withReuseIdentifier: GenderCollectionViewCell.reuseId, for: indexPath)
            let genderCell = cell as? GenderCollectionViewCell
            let gender = Gender.allCases[indexPath.row]
            genderCell?.configure(gender: gender, selected: shownGender)
            return cell
        case 2:
            // Section 2 is brands - use brands view controller section 0 if available to answer
            if let brandsViewController = showBrandsViewController {
                return brandsViewController.collectionView(collectionView, cellForItemAt: indexPath)
            }
            // Use occasion cell as brands summary cell
            let cell = collectionView
                .dequeueReusableCell(withReuseIdentifier: OccasionCollectionViewCell.reuseId, for: indexPath)
            let summaryCell = cell as? OccasionCollectionViewCell
            summaryCell?.configure(
                hideCheckBox: true,
                hideChevron: false,
                customLabel: "Selected \(Brands.selected.count) brands out of \(Brands.count)"~
            )
            return cell
        case 3:
            // Section 3 is Occasion - configure occasion cell
            let cell = collectionView
                .dequeueReusableCell(withReuseIdentifier: OccasionCollectionViewCell.reuseId, for: indexPath)
            // Configure one cell with simple text
            let occasionCell = cell as? OccasionCollectionViewCell
            let occasions = Occasions.selectedUniqueTitle.sorted()
            let occasion = occasions[indexPath.row]
            shouldShowSummary(of: occasions) ? occasionCell?.configure(
                with: occasion,
                hideCheckBox: true,
                hideChevron: false,
                customLabel: "Selected \(occasions.count) occasions out of \(Occasions.titles.count)"~
            ) : occasionCell?.configure(with: occasion)
            return cell
        case 4:
            // Section 4 is Feeds - configure feed cell
            let cell = collectionView
                .dequeueReusableCell(withReuseIdentifier: FeedsCollectionViewCell.reuseId, for: indexPath)
            let feedCell = cell as? FeedsCollectionViewCell
            let allFeeds = FeedsProfile.all
            let selectedFeeds = allFeeds.selected
            let feed = selectedFeeds[indexPath.row]
            shouldShowSummary(of: selectedFeeds) ? feedCell?.configure(
                with: feed,
                hideChevron: false,
                customLabel: "Selected \(selectedFeeds.count) of \(allFeeds.count) feeds"~
            ) : feedCell?.configure(with: feed)
            return cell
        default:
            debug("WARNING: Unknown section \(indexPath.section), row \(indexPath.row)")
            return UICollectionViewCell()
        }
    }
    
    /// Configure and provide section header for the profile collection view
    /// - Parameters:
    ///   - collectionView: profile collection view
    ///   - section: UICollectionView.elementKindSectionHeader
    ///   - indexPath: index path of given section
    /// - Returns: section header for the profile collection view
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let supplementaryView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: ProfileSectionHeaderView.reuseId,
                for: indexPath
            )
            let headerView = supplementaryView as? ProfileSectionHeaderView
            headerView?.configure(title: ProfileViewController.sectionHeaders[indexPath.section])
            return supplementaryView
        default:
            debug("WARNING: Unknown pick \(kind) in section \(indexPath.section), row \(indexPath.row)")
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
            return hasAccountCredentials ? sequenceCredentials.count : 1
        case 1:
            // Section 1 is gender — 3 items
            return Gender.allCases.count
        case 2:
            // Section 2 is brands - use brands view controller section 0 if available to answer
            guard let brandsViewController = showBrandsViewController else { return 1 }
            return brandsViewController.collectionView(collectionView, numberOfItemsInSection: 0)
        case 3:
            // Section 3 is occasion — show a summary or selected occasions.
            let occasionsSelected = Occasions.selectedUniqueTitle
            return shouldShowSummary(of: occasionsSelected) ? 1 : occasionsSelected.count
        case 4:
            // Section 4 is feeds — show a summary or selected feeds.
            let feedsSelected = FeedsProfile.all.selected
            return shouldShowSummary(of: feedsSelected) ? 1 : feedsSelected.count
            
        default:
            debug("WARNING: Unknown section \(section)")
            return 0
        }
    }
    
    /// Returns the number of sections in profile collection view: 2 (gender and brands)
    /// - Parameter collectionView: profile collection view
    /// - Returns: the number of sections in profile collection view
    func numberOfSections(in collectionView: UICollectionView) -> Int { ProfileViewController.sectionHeaders.count }
    
    // MARK: - Private / Internal Properties
    /// True if user account credentials are available
    private var hasAccountCredentials: Bool {
        User.current.isLoggedIn != nil && !userCredentials.isEmpty
    }
    
    /// Returns brands view controller if there are 1 to `maxItemCount` brands to show
    internal var showBrandsViewController: BrandsViewController? {
        shouldShowSummary(of: Brands.selected) ? nil : BrandsViewController.default
    }
    
    /// Returns true if there are no or too many elements of an array
    /// - Parameter elements: an array of elements
    /// - Returns: true if there are no or too many (more than `maxItemCount`) elements
    private func shouldShowSummary<T>(of elements: Array<T>) -> Bool {
        shouldShowSummary(of: AnyCollection(elements))
    }
    
    /// Returns true if there are no or too many elements of a dictionary
    /// - Parameter elements: a dictionary of elements
    /// - Returns: true if there are no or too many (more than `maxItemCount`) elements
    private func shouldShowSummary<T, U>(of elements: Dictionary<T, U>) -> Bool {
        shouldShowSummary(of: AnyCollection(elements))
    }
    
    /// Returns true if there are no or too many elements of a collection
    /// - Parameter elements: any collection of elements
    /// - Returns: true if there are no or too many (more than `maxItemCount`) elements
    private func shouldShowSummary<T>(of elements: AnyCollection<T>) -> Bool {
        elements.isEmpty || maxItemCount < elements.count
    }
}
