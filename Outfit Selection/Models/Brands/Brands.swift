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
    /// Brands filtered by filter
    var filtered: Brands {
        let filterString = Brands.filterString.lowercased()
        if filterString.isEmpty { return self }
        return filter { $0.value.name.lowercased().contains(filterString) }
    }
    
    /// Unique brand names
    var names: [String] { map { $0.value.name }.sorted() }
    
    /// All branded images sorted by selected first
    var prioritizeSelected: [Brand] {
        selected.map ({$0.value}).sorted() +
        unselected.map ({$0.value}).sorted()
    }
    
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
    
    /// All brands with logo image and filtered if nedded
    var withImage: Brands {
        let filterString = Brands.filterString.lowercased()
        
        // Filtered brands with image logo
        var withImage = filter { $0.value.image != nil }
        
        if filterString.isEmpty {
            
            // Return a dictionary with the combined keys and values
            return withImage.merging(selected) { (_, current) in current }
        }
        
        withImage = withImage.filter { $0.value.name.lowercased().contains(filterString)}
        let withoutImage = withoutImage.filter { $0.value.name.lowercased().contains(filterString)}
        
        // Return a dictionary with the combined keys and values
        return withImage.merging(withoutImage) { (_, current) in current }
    }
    
    /// All brands with logo image
    var withoutImage: Brands { filter { $0.value.image == nil } }
    
    // MARK: - Static Computed Properties
    /// Filter brand names by this string
    static var filterString = ""
    
    /// Brands filtered by filter string
    static var filtered: Brands { byName.filtered }
    
    /// Last selected branded image
    static var lastSelected: Bool?
    
    /// Filter brand names by this string
    static var names: [String] { byName.names }
    
    /// All branded images sorted by selected first
    static var prioritizeSelected: [Brand] { byName.prioritizeSelected }
    
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
