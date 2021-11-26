//
//  Occasions+all.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 09.09.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import Foundation

extension Occasions {
    
    // MARK: - Static Stored Properties
    /// All occasions as received from the server
    private static var all: [Occasion] = []
    
    /// Occasions by ID, not selected by default
    private(set) static var byID: [Int: Occasion] = [:]
    
    /// Occasions by title
    private(set) static var byTitle: [String: Occasions] = [:]
    
    /// The minimum number of items to keep the look in occasion
    private static let minItemsInLook = 2
    
    // MARK: - Static Computed Properties
    /// True if occasions are empty, false otherwise
    static var areEmpty: Bool { byID.isEmpty }
    
    /// The number of occasions
    static var count: Int { byID.count }
    
    /// Occasions filtered by current gender
    static var currentGender: Occasions {
        byID.values.filter { $0.gender == Gender.current || Gender.current == .other }
    }
    
    /// Unique flat item IDs for all occasions
    static var flatItemIDs: [String] {
        [String](all.flatMap { $0.flatItemIDs }.uniqued())
    }
    
    /// Unique flat subcategory IDs for all occasions
    static var flatSubcategoryIDs: [Int] {
        [Int](all.flatMap { $0.flatSubcategoryIDs }.uniqued())
    }
    
    /// The set of labels of all occasions
    static var labels: Set<String> { Set(byID.values.map({ $0.label }))}
    
    /// The set of names of all occasions
    static var names: Set<String> { Set(byID.values.map({ $0.name }))}
    
    /// The list of selected occasions
    static var selected: Occasions { byID.values.filter { $0.isSelected }}
    
    /// The list of selected occasions with unique title
    static var selectedUniqueTitle: Occasions { selected.titles.compactMap { byTitle[$0]?.first }}
    
    /// The IDs of selected occasions
    static var selectedIDs: [Int] { selected.map { $0.id }}
    
    /// The IDs of selected occasions with unique title
    static var selectedIDsUniqueTitle: [Int] { selectedUniqueTitle.map { $0.id }}
    
    /// The set of titles (name: label) of all occasions
    static var titles: Set<String> { Set(byID.values.map { $0.title })}
    
    /// The list of unselected occasions
    static var unselected: Occasions { byID.values.filter { !$0.isSelected }}
    
    // MARK: - Static Methods
    /// Append given occasion to `byId` and `byTitle`
    /// - Parameter occasion: occasion to add
    static func append(_ occasion: Occasion) {
        // Update server occasions
        all.append(occasion)
        
        // Ensure unique look categories
        occasion.corneredSubcategoryIDs = occasion.corneredSubcategoryIDs.map {
            [Int]($0.map { $0 }.uniqued())
        }
        byID[occasion.id] = occasion
        
        // Update occasions by title
        byTitle[occasion.title] = with(title: occasion.title)
    }
    
    /// Only keep occasions which have enough items to choose from
    /// - Parameter corneredItems: list of item lists in outfit view order
    static func filter(by corneredItems: [Items]) {
        // Save server occasions for future use and start from scratch
        let allOccasions = all
        removeAll()
        
        // Go through all occasions and keep only those which have enough items
        for occasion in allOccasions {
            // Go through each occasion look and check for enough items
            let subcategories = zip(corneredItems, occasion.subcategoryIDs)
                .filter { items, subcategoryIDs in
                    let matchingItems = items.filter {
                        $0.isMatching(subcategoryIDs)
                    }
                    return minItemsInLook <= matchingItems.count
                }
            
            // Add occasions which have items in each corner
            guard Corners.count == subcategories.count else { continue }
            append(occasion)
        }
        
        debug(
            "Occasions: \(allOccasions.titles.count) / \(allOccasions.count),",
            "selected: \(allOccasions.selected.titles.count) / \(allOccasions.selected.count),",
            "removed: \(allOccasions.titles.count - all.titles.count) / \(allOccasions.count - all.count),",
            "left: \(all.titles.count) / \(all.count),",
            "subcategories: \(all.flatSubcategoryIDs.count) of \(allOccasions.flatSubcategoryIDs.count)"
        )
    }
    
    /// Clears all occasions dictionary
    static func removeAll() {
        all.removeAll()
        byID.removeAll()
        byTitle.removeAll()
    }
    
    /// Select/deselect all occasions with given title
    /// - Parameters:
    ///   - title: the title to search for
    ///   - shouldSelect: true to select, false to unselect
    ///   - permanent: if true save to permanent storage (default), if false — don't
    static func select(title: String, shouldSelect: Bool, permanent: Bool = true) {
        selectWithoutSaving(title: title, shouldSelect: shouldSelect)
        if permanent { Occasions.saveSelectedOccasions() }
    }
    
    /// Select/deselect all occasions with given title without saving to user defaults
    /// - Parameters:
    ///   - title: the title to search for
    ///   - shouldSelect: true to select, false to unselect
    static func selectWithoutSaving(title: String, shouldSelect: Bool) {
        with(title: title).forEach { $0.selectWithoutSaving(shouldSelect) }
    }
    
    /// Update all occasions with given gender
    /// - Parameter gender: the gender to update occasions with
    static func updateWith(gender: Gender?) {
        // Don't update if gender is not set or is set to unisex
        guard let gender = gender, gender != .other else { return }
        
        // Remove all occasions with different gender
        byID.values
            .filter { $0.gender != gender }
            .forEach { byID[$0.id] = nil }
        
        // Match `by title` to `by id`
        byTitle.removeAll()
        titles.forEach { byTitle[$0] = with(title: $0) }
    }
    
    /// Returns all occasions with subcategories matching the items
    /// - Parameter items: items whose subcategories will be checked for intersection with occasions
    /// - Returns: the list of occasions matchin items subcategories
    static func with(items: Items) -> Occasions {
        byID.values.filter { occasion in
            // Make sure all items have subcategories common with occasion
            items.count == items.filter { !$0.subcategories(in: occasion).isEmpty }.count
        }
    }
    
    /// Returns all occasions with given title
    /// - Parameter title: the title to look for
    /// - Returns: the list of occasions with the title
    static func with(title: String) -> Occasions {
        byID.values.filter { $0.title == title }
    }
}
