//
//  Brands.swift
//  Outfit Selection
//
//  Created by Evgeniy Goncharov on 03.03.2022.
//  Copyright © 2022 Denis Bystruev. All rights reserved.
//

import Algorithms

typealias Brands = [Brand]

extension Brands {
    // MARK: - Computed Properties
    /// Unique brand names
    var names: UniquedSequence<[String], String> {
        map { $0.name }.uniqued()
    }
    
    /// All selected brands
    var selected: Brands {
        filter { $0.isSelected }
    }
    
    /// All unselected brands
    var unselected: Brands {
        filter { !$0.isSelected }
    }
    
    /// All  brands with logo image
    var withImage: Brands {
        filter { $0.image != nil }
    }
    
    /// All  brands with logo image
    var withoutImage: Brands {
        filter { $0.image == nil }
    }
}
