//
//  WishlistViewController+UICollectionViewDataSource.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 25.02.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import UIKit

extension WishlistViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { wishlist.count }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = wishlistCollectionView.dequeueReusableCell(withReuseIdentifier: wishlistCellId, for: indexPath)
        let wishlistElement = wishlist[indexPath.row]
        if let itemCell = cell as? ItemCell, let item = wishlistElement.item {
            itemCell.configure(with: item)
        } else if let outfitCell = cell as? OutfitCell {
            outfitCell.configure(with: wishlistElement)
        }
        return cell
    }
}
