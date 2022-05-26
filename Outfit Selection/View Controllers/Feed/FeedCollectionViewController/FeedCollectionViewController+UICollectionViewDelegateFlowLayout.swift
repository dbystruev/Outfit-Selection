//
//  FeedCollectionViewController+UICollectionViewDelegateFlowLayout.swift
//  Outfit Selection
//
//  Created by Evgeniy Goncharov on 25.05.2022.
//  Copyright © 2022 Denis Bystruev. All rights reserved.
//

import UIKit

// MARK: - UICollectionViewDelegateFlowLayout
extension FeedCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        debug(section)
        return CGSize(width: collectionView.frame.width, height: CGFloat(FeedSectionHeaderView.height))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        debug(indexPath)
        return CGSize(width: FeedItemCollectionCell.width, height: FeedItemCollectionCell.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
}
