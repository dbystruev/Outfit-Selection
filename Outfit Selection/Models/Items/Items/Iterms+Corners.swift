//
//  Iterms+Corners.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 29.10.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

extension Items {
    /// Reorder the items by given corners
    /// - Parameter corners: the corners to reorder the items by
    /// - Returns: the reordered items
    func corners(_ corners: Corners) -> Items {
        corners.compactMap {
            self[safe: $0.rawValue]
        }
    }
}
