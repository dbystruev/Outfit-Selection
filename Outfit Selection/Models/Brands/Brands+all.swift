//
//  Brands+all.swift
//  Outfit Selection
//
//  Created by Evgeniy Goncharov on 03.03.2022.
//  Copyright © 2022 Denis Bystruev. All rights reserved.
//

import Foundation

extension Brands {
    // MARK: - Static Stored Properties
    /// All brands
    private static var all: [Brand] = []
    
    // MARK: - Static Methods
    /// Append  brand to  all brands
    /// - Parameter brand: brand to add
    static func append(_ barand: Brand) {
        all.append(barand)
        
    }
}
