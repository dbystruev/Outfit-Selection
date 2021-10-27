//
//  FeedKind+CustomStringConvertible.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 29.09.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

extension FeedKind: CustomStringConvertible {
    /// CustomStringConvertible
    var description: String {
        switch self {
        case .brands:
            return ".brands"
        case .collections(let collectionName):
            return ".collections(\(collectionName)"
        case .newItems:
            return ".newItems"
        case .occasions(let occasionID):
            return ".occasions(\(occasionID))"
        case .sale:
            return ".sale"
        }
    }
}
