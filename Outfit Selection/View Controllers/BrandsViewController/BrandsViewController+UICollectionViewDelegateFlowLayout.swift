//
//  BrandsViewController+UICollectionViewDelegateFlowLayout.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 16.02.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import UIKit

extension BrandsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let side = cellSide
        return CGSize(width: side, height: side)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat { 0 }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat { 0 }
}
