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
        brandImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let brandImage = brandImages[indexPath.row]
        let cell = brandsCollectionView.dequeueReusableCell(withReuseIdentifier: "BrandCell", for: indexPath)
        let brandCell = cell as! BrandCell
        brandCell.brandImageView.alpha = brandImage.isSelected ? 1 : 0.125
        brandCell.brandImageView.image = brandImage
        return brandCell
    }
}
