//
//  FeedCollectionViewController+Configure.swift
//  Outfit Selection
//
//  Created by Evgeniy Goncharov on 22.04.2022.
//  Copyright © 2022 Denis Bystruev. All rights reserved.
//

import UIKit

extension FeedCollectionViewController {
    /// Compose layout for feed collection view
    /// - Parameter withBrandsOnTop: if true top row is brands row
    /// - Returns: collection view layout for feed collection view
     func configureLayout(withBrandsOnTop: Bool) -> UICollectionViewLayout {
        // Define cell spacing
        let spacing: CGFloat = 8
        
        // Define section header size
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(FeedSectionHeaderView.height)
        )
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        
        // Define the item size
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: spacing,
            bottom: 0,
            trailing: spacing
        )
        
        // Define the brand group size
        let brandCount = brandedImages.count
        let brandGroupSize = NSCollectionLayoutSize(
            widthDimension: .absolute((BrandCollectionViewCell.width + 2 * spacing) * CGFloat(brandCount)),
            heightDimension: .absolute(BrandCollectionViewCell.height + 2 * spacing)
        )
        let brandGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: brandGroupSize,
            subitem: item,
            count: brandCount
        )
        brandGroup.contentInsets = NSDirectionalEdgeInsets(
            top: spacing,
            leading: spacing,
            bottom: spacing,
            trailing: spacing
        )
        
        // Define brand section size
        let brandSection = NSCollectionLayoutSection(group: brandGroup)
        brandSection.boundarySupplementaryItems = [header]
        brandSection.interGroupSpacing = spacing
        brandSection.orthogonalScrollingBehavior = .continuous
        
        // Define the item group size
        let itemGroupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(FeedItemCollectionCell.width),
            heightDimension: .absolute(FeedItemCollectionCell.height)
        )
        let itemGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: itemGroupSize,
            subitems: [item]
        )
        itemGroup.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 0,
            bottom: 0,
            trailing: 0
        )
        
        // Define item section size
        let itemSection = NSCollectionLayoutSection(group: itemGroup)
        itemSection.boundarySupplementaryItems = [header]
        itemSection.interGroupSpacing = spacing
        itemSection.orthogonalScrollingBehavior = .continuous
        
        // Define the layout size
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in
            withBrandsOnTop && sectionIndex == 0 ? brandSection : itemSection
        }
         
        return layout
    }
    
}
