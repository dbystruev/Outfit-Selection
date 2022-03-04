//
//  Brands.swift
//  Outfit Selection
//
//  Created by Evgeniy Goncharov on 03.03.2022.
//  Copyright © 2022 Denis Bystruev. All rights reserved.
//

import Algorithms

typealias Brands = [String: Brand]

extension Brands {
    // MARK: - Computed Properties
    /// Unique brand names
    var names: [String] { map { $0.value.name }.sorted() }
    
    /// All selected brands
    var selected: Brands { filter { $0.value.isSelected } }
    
    /// All unselected brands
    var unselected: Brands { filter { !$0.value.isSelected } }
    
    /// All brands with logo image
    var withImage: Brands { filter { $0.value.image != nil } }
    
    /// All brands with logo image
    var withoutImage: Brands { filter { $0.value.image == nil } }
    
    
    // MARK: - Static Computed Properties
    /// Unique brand names
    static var names: [String] { byName.names }
    
    /// All selected brands
    static var selected: Brands { byName.selected }
    
    /// All unselected brands
    static var unselected: Brands { byName.unselected }
    
    /// All brands with logo image
    static var withImage: Brands { byName.withImage }
    
    /// All brands with logo image
    static var withoutImage: Brands { byName.withoutImage }
}
