//
//  FeedBrandCell+UICollectionViewDataSource.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 25.08.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import UIKit

extension FeedBrandCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        brandedImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BrandCollectionViewCell.reuseId, for: indexPath)
        let brandCell = cell as? BrandCollectionViewCell ?? BrandCollectionViewCell(frame: cell.frame)
        brandCell.configure(brandedImage: brandedImages[indexPath.row], cellSize: cellSize(for: collectionView))
        return brandCell
    }
}
