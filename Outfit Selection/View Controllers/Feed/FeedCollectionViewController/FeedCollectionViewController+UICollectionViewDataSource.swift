//
//  FeedCollectionViewController+UICollectionViewDataSource.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 28.09.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import UIKit

extension FeedCollectionViewController: UICollectionViewDataSource {
    /// Get cell for the given index path in collection view
    /// - Parameters:
    ///   - collectionView: collection view
    ///   - indexPath: index path to give the cell for
    /// - Returns: the cell for the given index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath ) -> UICollectionViewCell {
        
        // Switch for displayedPick type
        switch displayedPicks[indexPath.section].type {
        case .brands:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: BrandCollectionViewCell.reuseId,
                for: indexPath
            )
            
            guard let brandCell = cell as? BrandCollectionViewCell else {
                debug("WARNING: Can't cast \(cell) to \(BrandCollectionViewCell.self)")
                return cell
            }
            
            brandCell.configure(brand: Brands.prioritizeSelected[indexPath.item], cellSize: BrandCollectionViewCell.size)
            return brandCell
            
        case .emptyBrands:
            return UICollectionViewCell()
            
        case .hello:
            return UICollectionViewCell()
            
        default:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: FeedItemCollectionCell.reuseId,
                for: indexPath
            )
            
            guard let itemCell = cell as? FeedItemCollectionCell else {
                debug("WARNING: Can't cast \(cell) to \(FeedItemCollectionCell.self)")
                return cell
            }
            
            // Configure content for cell in section
            let pick = displayedPicks[indexPath.section]
            if let item = pickItems[pick]?[indexPath.item] {
                itemCell.configureContent(pick: pick, item: item, isInteractive: true)
            }
            
            itemCell.delegate = self
            return itemCell
        }
    }
    
    /// Returns the number of items in each section of collection view
    /// - Parameters:
    ///   - collectionView: feed collection view
    ///   - section: section number to return the number of items for
    /// - Returns: the number of items in given section of  collection view
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let pick = displayedPicks[section]
        let count = pickItems[pick]?.count ?? 0
        return count
    }
    
    /// Returns the number of sections in collection view
    /// - Parameter collectionView: collection view
    /// - Returns: the number of sections in  collection view
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return displayedPicks.count
    }
    
    /// Configure and provide section header for the collection view
    /// - Parameters:
    ///   - collectionView: profile collection view
    ///   - kind: UICollectionView.elementKindSectionHeader
    ///   - indexPath: index path of given section
    /// - Returns: section header for the  collection view
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else { return UICollectionReusableView() }
        
        let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: FeedSectionHeaderView.reuseId,
            for: indexPath
        )
        
        guard let feedHeader = header as? FeedSectionHeaderView else {
            debug("WARNINIG: Can't cast \(header) to \(FeedSectionHeaderView.self)")
            return header
        }
        
        feedHeader.configureContent(pick: displayedPicks[indexPath.section % displayedPicks.count])
        feedHeader.delegate = self
        return feedHeader
    }
    
}
