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
        // Brands.count
        brandedImages.filtered.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BrandCollectionViewCell.reuseId, for: indexPath)
        if cell as? BrandCollectionViewCell == nil {
            debug("WARNING: Can't cast \(BrandCollectionViewCell.reuseId) to \(BrandCollectionViewCell.self)")
        }
        
        let brandCell = cell as? BrandCollectionViewCell ?? BrandCollectionViewCell(frame: cell.frame)
        brandCell.configure(brandedImage: brandedImages.filtered[indexPath.row], cellSize: cellSize(for: collectionView))
        
//        // TODO: Delete me
//        let brandCell = cell as? BrandCollectionViewCell ?? BrandCollectionViewCell(frame: cell.frame)
//
//        // Get brands with logos and sorted it by name
//        let sorteredBrandWitnImages = Brands.withImage.map({ $0.value }).sorted(by: { $0.name < $1.name })
//
//        // Get brands without logos and sorted it by name
//        let serteredBrandWithoutImages = Brands.withoutImage.map({ $0.value }).sorted(by: { $0.name < $1.name })
//
//        // Final sorted brands with logo sorted by name, after brand name sorted by name without logo
//        let finalBrands = sorteredBrandWitnImages + serteredBrandWithoutImages
//
//        brandCell.configure(brand: finalBrands[indexPath.row], cellSize: cellSize(for: collectionView))
        
        return brandCell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else { return UICollectionReusableView() }
        
        return collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: BrandsSearchCollectionView.reuseId,
            for: indexPath
        )
    }
}
