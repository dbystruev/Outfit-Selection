//
//  BrandsViewController+UICollectionViewDelegate.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 27.11.2020.
//  Copyright © 2020 Denis Bystruev. All rights reserved.
//

import UIKit

extension BrandsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let brandCell = collectionView.cellForItem(at: indexPath) as? BrandCell else { return }
        let brandImage = brandImages[indexPath.row]
        
        // Toggle alpha between 0.125 and 1
        brandImage.isSelected.toggle()
        brandCell.brandImageView.alpha = brandImage.isSelected ? 1 : 0.125
    }
}
