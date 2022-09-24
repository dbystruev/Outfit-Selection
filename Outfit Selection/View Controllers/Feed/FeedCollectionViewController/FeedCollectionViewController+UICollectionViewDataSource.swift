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
        
        var sectionType: PickType = .hello
        
        switch collectionView {
            
        case feedCollectionView:
            sectionType = displayedPicks[indexPath.section].type
        default:
            sectionType = items[indexPath.section].key
//            sectionType = PickType.collections(collection[indexPath.section].name)
        }
        
        // Switch for displayedPick type
        switch sectionType {
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
            
            switch collectionView {
            case feedCollectionView:
                
                // Configure content for cell in section
                let pick = displayedPicks[indexPath.section]
                if let item = pickItems[pick]?[indexPath.item] {
                    itemCell.configureContent(pick: pick, item: item, isInteractive: true)
                }
                
            default:
                // Configure content for cell in section
                let kind = items[indexPath.section].key
                if let item = items[kind]?[indexPath.item] {
                    itemCell.configureContent(
                        kind: kind,
                        item: item,
                        isInteractive: true
                    )
                }

//                // Configure content for cell in section
//                let kind = PickType.collections(collection[indexPath.section].name)
//                let item = collection[indexPath.section].items[indexPath.item]
//                itemCell.configureContent(kind: kind, item: item,isInteractive: true)
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
        switch collectionView {
        case feedCollectionView:
            let pick = displayedPicks[section]
            let count = pickItems[pick]?.count ?? 0
            return count
        default:
//            let kind = PickType.collections(collection[section].name)
            let kind = items[section].key
            let count = kind == .brands ? Brands.sorted.count : items[kind]?.count ?? 0
//            let count = kind == .brands ? Brands.sorted.count : collection[section].items.count
            return count
        }
        
    }
    
    /// Returns the number of sections in collection view
    /// - Parameter collectionView: collection view
    /// - Returns: the number of sections in  collection view
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        switch collectionView {
        case feedCollectionView:
            return displayedPicks.count
        default:
            return items.count
//            return collection.count
        }
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
        
        switch collectionView {
        case feedCollectionView:
            feedHeader.configureContent(pick: displayedPicks[indexPath.section % displayedPicks.count])
        default:
            feedHeader.configureContent(kind: items[indexPath.section % items.count].key, indexSection: indexPath.section, id: "")
//            feedHeader.configureContent(kind: PickType.collections(collection[indexPath.section].name), indexSection: indexPath.section, id: collection[indexPath.section].id)
        }
        
        feedHeader.delegate = self
        return feedHeader
    }
    
}
