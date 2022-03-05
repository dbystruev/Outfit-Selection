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

    /// Brand images filtere by brand
    //var filtered: Brands { filter { filter.isEmpty ? true : $0.branded([filter]) } }
    
    /// Unique brand names
    var names: [String] { map { $0.value.name }.sorted() }
    
    /// Sortered array with brand, first brands with image, after sortered without image
    var sorted: [Brand] {
        // Brands with logos and sorted it by name
        withImage.map({ $0.value }).sorted() +
        
        // Brands without logos and sorted it by name
        withoutImage.map({ $0.value }).sorted()
    }
    
    /// All selected brands
    var selected: Brands { filter { $0.value.isSelected } }
    
    /// All unselected brands
    var unselected: Brands { filter { !$0.value.isSelected } }
    
    /// All brands with logo image
    var withImage: Brands { filter { $0.value.image != nil } }
    
    /// All brands with logo image
    var withoutImage: Brands { filter { $0.value.image == nil } }
    
    // MARK: - Static Computed Properties
    /// Last selected branded image
    static var lastSelected: Bool?
    
    /// Filter brand names by this string
    static var filter = ""
    
    /// Brand images filtere by brand
    //static var filtered: Brands { byName.filtered }
    
    /// Filter brand names by this string
    static var names: [String] { byName.names }
    
    /// Sortered array with brand, first brands with image, after sortered without image
    static var sorted: [Brand] { byName.sorted }
    
    /// All selected brands
    static var selected: Brands { byName.selected }
    
    /// All unselected brands
    static var unselected: Brands { byName.unselected }
    
    /// All brands with logo image
    static var withImage: Brands { byName.withImage }
    
    /// All brands with logo image
    static var withoutImage: Brands { byName.withoutImage }
}
