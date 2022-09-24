//
//  ProfileViewController+UICollectionViewDataSource.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 28.02.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import CryptoKit
import UIKit

// MARK: - UICollectionViewDataSource
extension ProfileViewController: UICollectionViewDataSource {
    // MARK: - Private Types
    internal enum Section: Int, CaseIterable {
        case account
        case gender
        case currency
        case brands
        case occasions
        case feeds
    }
    
    // MARK: - Private Static Properties
    private static let sectionHeaders = [
        "Account"~, "Gender"~, "Currency"~, "Brands"~, "Occasions"~, "Feeds"~
    ]
    
    // MARK: - UICollectionViewDataSource Methods
    /// Get cell for the given index path in profile collection view
    /// - Parameters:
    ///   - collectionView: profile collection view
    ///   - indexPath: index path to give the cell for
    /// - Returns: the cell for the given index path
    func collectionView(
        _ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        switch indexPath.section {
        // Section 0 is account credentials - configure account cell
        case Section.account.rawValue:
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
        // Section 1 is gender - configure gender cell
        case Section.gender.rawValue:
            let cell = collectionView
                .dequeueReusableCell(withReuseIdentifier: GenderCollectionViewCell.reuseId, for: indexPath)
            let genderCell = cell as? GenderCollectionViewCell
            let gender = Gender.allCases[indexPath.row]
            genderCell?.configure(gender: gender, selected: shownGender)
            return cell
        // Section 2 is currency — use occasion cell from section 4 as placeholder
        case Section.currency.rawValue:
            let cell = collectionView
                .dequeueReusableCell(withReuseIdentifier: OccasionCollectionViewCell.reuseId, for: indexPath)
            let occasionCell = cell as? OccasionCollectionViewCell
            occasionCell?.configure(
                customLabel: "Convert to AED"~,
                customSelected: UserDefaults.convertToAED
            )
            return cell
        // Section 3 is brands - use brands view controller section 0 if available to answer
        case Section.brands.rawValue:
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
        // Section 4 is Occasion - configure occasion cell
        case Section.occasions.rawValue:
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
        // Section 5 is Feeds - configure feed cell
        case Section.feeds.rawValue:
            let cell = collectionView
                .dequeueReusableCell(withReuseIdentifier: FeedsCollectionViewCell.reuseId, for: indexPath)
            let feedCell = cell as? FeedsCollectionViewCell
            let allFeeds = Feeds.all
            let selectedFeeds = allFeeds.selected
            let feed = selectedFeeds[safe: indexPath.row] ?? allFeeds[0]
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
        // Section 0 is user info with avaliable properties
        case Section.account.rawValue:
            return hasAccountCredentials ? sequenceCredentials.count : 1
        // Section 1 is gender — 3 items
        case Section.gender.rawValue:
            return Gender.allCases.count
        // Section 2 is currency — 1 item
        case Section.currency.rawValue:
            return 1
        // Section 3 is brands - use brands view controller section 0 if available to answer
        case Section.brands.rawValue:
            guard let brandsViewController = showBrandsViewController else { return 1 }
            return brandsViewController.collectionView(collectionView, numberOfItemsInSection: 0)
        // Section 4 is occasion — show a summary or selected occasions.
        case Section.occasions.rawValue:
            let occasionsSelected = Occasions.selectedUniqueTitle
            return shouldShowSummary(of: occasionsSelected) ? 1 : occasionsSelected.count
        // Section 5 is feeds — show a summary or selected feeds.
        case Section.feeds.rawValue:
            let feedsSelected = Feeds.all.selected
            return shouldShowSummary(of: feedsSelected) ? 1 : feedsSelected.count
        // Unknown section
        default:
            debug("WARNING: Unknown section \(section)")
            return 0
        }
    }
    
    /// Returns the number of sections in profile collection view: 2 (gender and brands)
    /// - Parameter collectionView: profile collection view
    /// - Returns: the number of sections in profile collection view
    func numberOfSections(in collectionView: UICollectionView) -> Int { Section.allCases.count }
    
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
