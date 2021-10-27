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
    
    /// Occasion gender
    let gender: Gender
    
    /// Occasion label (2nd level name)
    let label: String
    
    /// Occasion looks (subcategories)
    let looks: [[Int]]
    
    /// The name of the occasion
    let name: String
    
    /// Occasion id (for Equatable)
    let id: Int
    
    // MARK: - Computed Properties
    var isSelected: Bool {
        get { _isSelected }
        set {
            guard _isSelected != newValue else { return }
            _isSelected = newValue
            DispatchQueue.global(qos: .background).async {
                Occasion.saveSelectedOccasions()
            }
        }
    }
    
    // MARK: - Types
    enum CodingKeys: String, CodingKey {
        case categoryIDs = "category_ids"
        case gender
        case id
        case label
        case looks
        case name
    }
    
    // MARK: - Init
    /// Constructor for occasion
    /// - Parameters:
    ///   - name: the name of the occasion
    ///   - label: occasion label (2nd level name)
    ///   - categoryIDs: category IDs which belong to the occasion
    ///   - isSelected: whether the occasion is selected by the user, false by default
    init(
        _ name: String,
        label: String,
        categoryIDs: [Int],
        gender: Gender,
        looks: [[Int]],
        id: Int,
        isSelected: Bool = false
    ) {
        self._isSelected = isSelected
        self.categoryIDs = categoryIDs
        self.gender = gender
        self.id = id
        self.label = label
        self.looks = looks
        self.name = name
    }
    
    // MARK: - Methods
    /// Select / deselect this occasion without updating user defaults
    /// - Parameter isSelected: true if should select, false if should unselect
    func selectWithoutSaving(_ isSelected: Bool) {
        _isSelected = isSelected
    }
}

// MARK: - UserDefaults
extension Occasion {
    // MARK: - Static Methods
    /// Load selected occasion names from user defaults and updated Occasion.all
    static func restore() {
        // Get selected occasion names and make sure they are not empty
        let selectedIdsRestored = UserDefaults.selectedOccasionIDs
        guard !selectedIdsRestored.isEmpty else {
            debug("WARNING: Occasion list in user defaults is empty")
            return
        }
        
        var selectedOccasionsCount = 0
        
        for selectedRestoredId in selectedIdsRestored {
            guard let occasion = Occasion.all[selectedRestoredId] else { continue }
            occasion.isSelected = true
            selectedOccasionsCount += 1
        }
        
        debug(
            "Occasions: \(selectedIdsRestored.count) loaded,",
            "\(selectedOccasionsCount) of \(Occasion.all.count) selected"
        )
    }
    
    /// Save selected occasion names to user defaults
    static func saveSelectedOccasions() {
        UserDefaults.selectedOccasionIDs = selectedIDs
    }
}
