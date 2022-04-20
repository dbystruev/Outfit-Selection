//
//  FeedCollectionViewController+UICollectionViewDataSource.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 28.09.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import UIKit

extension FeedCollectionViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        switch sections[indexPath.section] {
        
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
            let kind = sections[indexPath.section]
            if let item = items[kind]?[indexPath.item] {
                itemCell.configureContent(
                    kind: kind,
                    item: item,
                    isInteractive: true
                )
            }
            
            itemCell.delegate = self
            return itemCell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let kind = sections[section]
        let count = kind == .brands ? Brands.sorted.count : items[kind]?.count ?? 0
        return count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        let count = sections.count
        return count
    }
    
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
        
        feedHeader.configureContent(kind: sections[indexPath.section % sections.count])
        feedHeader.delegate = self
        return feedHeader
    }
}
