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
        brands.count
        //brandedImages.filtered.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BrandCollectionViewCell.reuseId, for: indexPath)
        if cell as? BrandCollectionViewCell == nil {
            debug("WARNING: Can't cast \(BrandCollectionViewCell.reuseId) to \(BrandCollectionViewCell.self)")
        }
        
        let brandCell = cell as? BrandCollectionViewCell ?? BrandCollectionViewCell(frame: cell.frame)
        //brandCell.configure(brandedImage: brandedImages.filtered[indexPath.row], cellSize: cellSize(for: collectionView))
        brandCell.configure(brand: brands[indexPath.row], cellSize: cellSize(for: collectionView))
        
        return brandCell
    }
}
