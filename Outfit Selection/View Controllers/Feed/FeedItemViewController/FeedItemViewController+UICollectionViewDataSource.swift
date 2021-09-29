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
        let itemCell: FeedCollectionViewCell = {
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: FeedCollectionViewCell.reuseId,
                for: indexPath
            )
            guard let itemCell = cell as? FeedCollectionViewCell else {
                debug("WARNING: Can't cast \(cell) as \(FeedCollectionViewCell.self)")
                let itemCell = FeedCollectionViewCell()
                return itemCell
            }
            return itemCell
        }()
        
        // Configure the cell with matching item and return
        itemCell.configureContent(kind: kind, item: items[indexPath.row], isInteractive: true)
        
        // Set feed view controller as delegate for item button tapped
        let controllers = navigationController?.viewControllers
        let feedViewController = controllers == nil ? nil : controllers![safe: controllers!.count - 2]
        guard let delegate = feedViewController as? ButtonDelegate else {
            debug("WARNING: Can't set \(String(describing: feedViewController)) as \(ButtonDelegate.self)")
            return itemCell
        }
        itemCell.delegate = delegate
        return itemCell
    }
    
    
}
