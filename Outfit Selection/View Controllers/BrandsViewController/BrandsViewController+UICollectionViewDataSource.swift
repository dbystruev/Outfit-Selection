//
//  BrandsViewController+UICollectionViewDataSource.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 27.11.2020.
//  Copyright © 2020 Denis Bystruev. All rights reserved.
//

import UIKit

extension BrandsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        brandedImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let brandImage = brandedImages[indexPath.row]
        let cell = brandsCollectionView.dequeueReusableCell(withReuseIdentifier: "BrandCell", for: indexPath)
        let brandCell = cell as! BrandCell
        brandCell.brandImageView.alpha = brandImage.isSelected ? 1 : 0.25
        brandCell.brandImageView.image = brandImage
        
        // Set min brand view image height and width
        let cellSide = (collectionView.bounds.size.width - 32) / 3
        brandCell.brandImageViewHeightConstraint.constant = cellSide - 2 * BrandCell.verticalPadding
        brandCell.brandImageViewWidthConstraint.constant = cellSide - 2 * BrandCell.horizontalPadding
        brandCell.horizontalPaddingConstraints.forEach { $0.constant = BrandCell.horizontalPadding }
        brandCell.verticalPaddingConstraints.forEach { $0.constant = BrandCell.verticalPadding }
        
        return brandCell
    }
}
