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
        let cellWidth = (collectionView.bounds.size.width - 32) / 3
        brandCell.brandImageViewHeightConstraint.constant = cellWidth - 2 * BrandCell.padding
        brandCell.brandImageViewWidthConstraint.constant = cellWidth - 2 * BrandCell.padding
        brandCell.paddingConstraints.forEach { $0.constant = BrandCell.padding }
        
        return brandCell
    }
}
