//
//  Occasions.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 27.10.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import Algorithms

typealias Occasions = [Occasion]

extension Occasions {
    // MARK: - Computed Properties
    /// True if array or occasions is empty, false otherwise
    var areEmpty: Bool { isEmpty }
    
    /// Item IDs from top left clockwise matching cornered subcategory IDs
    var corneredItemIDs: [[String]] {
        // Array where we accumulate items from different corners
        guard let maxCount = self
                .max(by: { $0.corneredItemIDs.count < $1.corneredItemIDs.count })?
                .corneredItemIDs
                .count
        else { return [] }
        var corneredItemIDs = [[String]](repeating: [], count: maxCount)
        
        // Go through each corner from top left clockwise
        for cornerIndex in 0 ..< maxCount {
            let itemIDs = compactMap { $0.corneredItemIDs[safe: cornerIndex] }
                .flatMap { $0 }
                .uniqued()
            corneredItemIDs[cornerIndex] = [String](itemIDs)
        }
        
        return corneredItemIDs
    }
    
    /// Occasions filtered by current gender
    var currentGender: Occasions {
        gender(Gender.current)
    }
    
    /// First occasion which is selected
    var firstSelected: Occasion? {
        selected.first
    }
    
    /// Unique flat subcategory IDs for all occasions
    var flatSubcategoryIDs: [Int] {
        [Int](flatMap { $0.flatSubcategoryIDs }.uniqued())
    }
    
    /// Occasion labels
    var labels: UniquedSequence<[String], String> {
        map { $0.label }.uniqued()
    }
    
    /// Occasion names
    var names: UniquedSequence<[String], String> {
        map { $0.name }.uniqued()
    }
    
    /// All selected occasions
    var selected: Occasions {
        filter { $0.isSelected }
    }
    
    /// All occasions, but selected are first
    var selectedFirst: Occasions {
        selected + unselected
    }
    
    /// The set of titles (name: label) of all occasions
    var titles: Set<String> { Set(map { $0.title })}
    
    /// All unselected occasions
    var unselected: Occasions {
        filter { !$0.isSelected }
    }
    
    // MARK: - Methods
    /// Filter occasions for given gender
    /// - Parameter gender: the gender to filter occasions for
    /// - Returns: the list of occasions with given or .other gender, or all occasions if given gender is nil or _other
    func gender(_ gender: Gender?) -> Occasions {
        // If gender is not set or is .other all occasions are OK
        guard let gender = gender, gender != .other else { return self }
        
        // For unisex all genders are OK, otherwise match the genders
        return filter {
            $0.gender == gender || $0.gender == .other
        }
    }
    
    /// Returns all occasions with given name
    /// - Parameter name: the title to look for
    /// - Returns: the list of occasions with the name
    func with(name: String) -> Occasions {
        filter { $0.name == name }
    }
    
    /// Returns all occasions with given label
    /// - Parameter label: the label to look for
    /// - Returns: the list of occasions with the label
    func with(label: String) -> Occasions {
        filter { $0.label == label }
    }
    
    /// Returns all occasions with given title
    /// - Parameter title: the title to look for
    /// - Returns: the list of occasions with the title
    func with(title: String) -> Occasions {
        filter { $0.title == title }
    }
}
