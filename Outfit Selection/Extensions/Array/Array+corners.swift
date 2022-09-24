//
//  Array+corners.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 29.10.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

extension Array {
    /// Reorder the elements by given corners
    /// - Parameter corners: the corners to reorder the elements by
    /// - Returns: the reordered elements
    func corners(_ corners: Corners) -> [Element] {
        corners.compactMap {
            self[safe: $0.rawValue]
        }
    }
}
