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
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case 0:
            // Section 0 is gender - 1 item per row
            return CGSize(width: collectionView.bounds.width, height: 44)
        case 1:
            // Section 1 is brands — reuse brands view controller to answer
            return brandsViewController?.collectionView(collectionView, layout: collectionViewLayout, sizeForItemAt: indexPath) ?? CGSize.zero
        default:
            debug("WARNING: Unknown section \(indexPath.section)")
            return CGSize.zero
        }
    }
}
