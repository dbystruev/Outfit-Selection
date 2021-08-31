//
//  FeedItemViewController+UICollectionViewDataSource.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 27.08.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import UIKit

extension FeedItemViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Dequeue or create feed item collection view cell
        let itemCell: FeedItemCollectionViewCell = {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedItemCollectionViewCell.reuseId, for: indexPath)
            guard let itemCell = cell as? FeedItemCollectionViewCell else {
                debug("WARNING: Can't dequeue cell with id \(FeedItemCollectionViewCell.reuseId)")
                let itemCell = FeedItemCollectionViewCell()
                return itemCell
            }
            return itemCell
        }()
        
        // Configure the cell with matching item and return
        itemCell.configureContent(kind: kind, item: items[indexPath.row])
        
        // Set feed view controller as delegate for item button tapped
        if let controllers = navigationController?.viewControllers, let delegate = controllers[safe: controllers.count - 2] as? ButtonDelegate {
            itemCell.delegate = delegate
        }
        return itemCell
    }
    
    
}
