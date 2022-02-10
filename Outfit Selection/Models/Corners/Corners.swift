//
//  Corners.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 29.10.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

typealias Corners = [Corner]

extension Corners {
    /// The number of corners
    static var count: Int { Corner.allCases.count }
    
    /// The array of empty corners matching count
    static var empty: [[Int]] {
        [[Int]](repeating: [], count: count)
    }
    
    /// Convert corners from occasions order to outfit order
    static var occasions: Corners {
        [.topLeft, .bottomLeft, .topRight, .middleRight, .bottomRight]
    }
    
    /// Convert corners from occasions order to outfit order
    static var occasionsFromUrl: Corners {
        [.topRight, .bottomLeft, .bottomRight, .topLeft, .middleRight]
    }
    
    /// Convert corners from outfit order to the same outfit order
    static var outfit: Corners { Corner.allCases }
}
