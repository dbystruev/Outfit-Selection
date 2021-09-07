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
        // Obtain the cell from wishilist collection view
        let cell = wishlistCollectionView.dequeueReusableCell(withReuseIdentifier: wishlistCellId, for: indexPath)
        
        // If we are not serving for ourselves, use self as button delegate
        let delegate = collectionView == wishlistCollectionView ? nil : self
        
        // Configure an item or an outfit
        let wishlistElement = wishlist[indexPath.row]
        if let itemCell = cell as? WishlistItemCell, let item = wishlistElement.item {
            itemCell.configure(with: item, delegate: delegate)
        } else if let outfitCell = cell as? WishlistOutfitCell {
            outfitCell.configure(with: wishlistElement, delegate: delegate)
        }
        return cell
    }
}
