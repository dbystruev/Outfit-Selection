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
        case .newItems:
            return ".newItems"
        case .occasions(let occasion):
            return ".occasions(\(occasion)"
        case .sale:
            return ".sale"
        }
    }
}
