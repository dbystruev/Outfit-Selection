//
//  IBPCollectionViewCompositionalLayoutInteroperability.swift.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 28.09.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//
//  https://github.com/kishikawakatsumi/IBPCollectionViewCompositionalLayout

// swiftlint:disable all
import IBPCollectionViewCompositionalLayout

typealias NSCollectionLayoutAnchor = IBPNSCollectionLayoutAnchor
typealias NSCollectionLayoutBoundarySupplementaryItem = IBPNSCollectionLayoutBoundarySupplementaryItem
typealias NSCollectionLayoutDecorationItem = IBPNSCollectionLayoutDecorationItem
typealias NSCollectionLayoutDimension = IBPNSCollectionLayoutDimension
typealias NSCollectionLayoutEdgeSpacing = IBPNSCollectionLayoutEdgeSpacing
typealias NSCollectionLayoutEnvironment = IBPNSCollectionLayoutEnvironment
typealias NSCollectionLayoutGroup = IBPNSCollectionLayoutGroup
typealias NSCollectionLayoutGroupCustomItem = IBPNSCollectionLayoutGroupCustomItem
typealias NSCollectionLayoutItem = IBPNSCollectionLayoutItem
typealias NSCollectionLayoutSection = IBPNSCollectionLayoutSection
typealias NSCollectionLayoutSize = IBPNSCollectionLayoutSize
typealias NSCollectionLayoutSpacing = IBPNSCollectionLayoutSpacing
typealias NSCollectionLayoutSupplementaryItem = IBPNSCollectionLayoutSupplementaryItem
typealias NSCollectionLayoutVisibleItem = IBPNSCollectionLayoutVisibleItem
typealias NSDirectionalEdgeInsets = IBPNSDirectionalEdgeInsets
typealias UICollectionLayoutSectionOrthogonalScrollingBehavior = IBPUICollectionLayoutSectionOrthogonalScrollingBehavior
typealias UICollectionViewCompositionalLayout = IBPUICollectionViewCompositionalLayout
typealias UICollectionViewCompositionalLayoutConfiguration = IBPUICollectionViewCompositionalLayoutConfiguration

extension IBPNSDirectionalEdgeInsets {
    public static var zero: IBPNSDirectionalEdgeInsets {
        return IBPNSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
    }
}
