//
//  ProfileViewController+UICollectionViewDelegateFlowLayout.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 28.02.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import UIKit

// MARK: - UICollectionViewDelegateFlowLayout
extension ProfileViewController: UICollectionViewDelegateFlowLayout {
    /// Provides the size for the header view in given profile collection view section
    /// - Parameters:
    ///   - collectionView: profile collection view
    ///   - collectionViewLayout: the layout object that requests the size
    ///   - section: the section of the profile collection view to provide the header size for
    /// - Returns: header view size for the given section
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        CGSize(width: collectionView.bounds.width, height: CGFloat(profileCellHeight))
    }
    
    /// Provides the size for item in given profile collection view
    /// - Parameters:
    ///   - collectionView: profile collection view
    ///   - collectionViewLayout: the layout object that requests the size
    ///   - indexPath: the item's index path
    /// - Returns: size for the item with index path provided
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        // Section 0 is account, 1 is gender, 2 is currency - one item per row
        case Section.account.rawValue, Section.gender.rawValue, Section.currency.rawValue:
            return CGSize(width: collectionView.bounds.width, height: CGFloat(profileCellHeight))
        // Section 3 is brands — reuse brands view controller to answer
        case Section.brands.rawValue:
            guard let brandsViewController = showBrandsViewController else {
                return CGSize(width: collectionView.bounds.width, height: CGFloat(profileCellHeight))
            }
            return brandsViewController
                .collectionView(collectionView, layout: collectionViewLayout, sizeForItemAt: indexPath)
        // Section 4 is occasions — reuse occasion view controller to answer
        case Section.occasions.rawValue:
            return CGSize(width: collectionView.bounds.width, height: CGFloat(profileCellHeight))
        // Section 5 is feed with selected feeds
        case Section.feeds.rawValue:
            return CGSize(width: collectionView.bounds.width, height: CGFloat(profileCellHeight))
        default:
            debug("WARNING: Unknown section \(indexPath.section)")
            return CGSize.zero
        }
    }
}
