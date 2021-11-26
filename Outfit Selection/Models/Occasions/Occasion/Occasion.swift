//
//  Occasion.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 09.09.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import Foundation

/// Occasions to create looks for
final class Occasion: Codable {
    
    // MARK: - Stored Properties
    /// Flag showing if occasion is selected by the user
    private var _isSelected = false
    
    /// Category IDs which belong to the occasion
    let categoryIDs: [Int]
    
    /// Item IDs from top left clockwise matching cornered subcategory IDs
    var corneredItemIDs: [[String]]
    
    /// Occasion corners from top left clockwise with the list of subcategory IDs in each corner
    var corneredSubcategoryIDs: [[Int]]
    
    /// Occasion gender
    let gender: Gender
    
    /// Occasion label (2nd level name)
    var label: String
    
    /// The name of the occasion
    var name: String
    
    /// Occasion id (for Equatable)
    let id: Int
    
    // MARK: - Computed Properties
    /// Unique flat item IDs for the occasion
    var flatItemIDs: [String] {
        [String](corneredItemIDs.flatMap { $0.map { $0 }}.uniqued())
    }
    
    /// Unique flat subcategory IDs for the occasion
    var flatSubcategoryIDs: [Int] {
        [Int](corneredSubcategoryIDs.flatMap { $0.map { $0 }}.uniqued())
    }
    
    /// True if occasion is selected, false otherwise. When set, user defaults is updated.
    var isSelected: Bool {
        get { _isSelected }
        set {
            guard _isSelected != newValue else { return }
            _isSelected = newValue
            DispatchQueue.global(qos: .background).async {
                Occasions.saveSelectedOccasions()
            }
        }
    }
    
    /// Occasion corners in top left, bottom left, top right, middle right, and bottom right order
    var subcategoryIDs: [[Int]] {
        corneredSubcategoryIDs.corners(.occasions)
    }
    
    /// Occasion name and title togeher
    var title: String { "\(name): \(label)" }
    
    // MARK: - Types
    enum CodingKeys: String, CodingKey {
        case categoryIDs = "category_ids"
        case corneredItemIDs = "items"
        case corneredSubcategoryIDs = "looks"
        case gender
        case id
        case label
        case name
    }
    
    // MARK: - Init
    /// Constructor for occasion
    /// - Parameters:
    ///   - name: the name of the occasion
    ///   - label: occasion label (2nd level name)
    ///   - gender: gender occasion is suitable for
    ///   - categoryIDs: category IDs which belong to the occasion
    ///   - looks: 5 arrays of subcategory IDs for each corner
    ///   - id: occasion ID
    ///   - items: 5 arrays of item IDs for each corner
    ///   - isSelected: whether the occasion is selected by the user, false by default
    init(
        _ name: String,
        label: String,
        gender: Gender,
        categoryIDs: [Int],
        looks corneredSubcategoryIDs: [[Int]],
        id: Int,
        items corneredItemIDs: [[String]],
        isSelected: Bool = false
    ) {
        self._isSelected = isSelected
        self.categoryIDs = categoryIDs
        self.gender = gender
        self.id = id
        self.label = label
        self.corneredSubcategoryIDs = corneredSubcategoryIDs
        self.corneredItemIDs = corneredItemIDs
        self.name = name
    }
    
    // MARK: - Methods
    /// Select / deselect this occasion without updating user defaults
    /// - Parameter isSelected: true if should select, false if should unselect
    func selectWithoutSaving(_ isSelected: Bool) {
        _isSelected = isSelected
    }
}
