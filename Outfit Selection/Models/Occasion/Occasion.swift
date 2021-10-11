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
    /// The name of the occasion
    let name: String
    
    /// Category IDs which belong to the occasion
    let categoryIDs: [Int]
    
    /// Flag showing if occasion is selected by the user
    private var _isSelected = false
    
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
        case name
        case categoryIDs = "category_ids"
    }
    
    // MARK: - Init
    /// Constructor for occasion
    /// - Parameters:
    ///   - name: the name of the occasion
    ///   - categoryIDs: category IDs which belong to the occasion
    ///   - isSelected: whether the occasion is selected by the user, false by default
    init(_ name: String, categoryIDs: [Int], isSelected: Bool = false) {
        self.name = name
        self.categoryIDs = categoryIDs
        self._isSelected = isSelected
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
    // MARK: - Static Constants
    /// User defaults key
    static let userDefaultsKey = "GetOutfitSelectedOccasionsBrandsKey"
    
    // MARK: - Static Methods
    /// Load selected occasion names from user defaults and updated Occasion.all
    static func restore() {
        guard
            let selectedNamesRestored = UserDefaults.standard.object(forKey: userDefaultsKey) as? [String]
        else {
            debug("WARNING: Can't find data from user defaults for key \(userDefaultsKey)")
            return
        }
        guard !selectedNamesRestored.isEmpty else {
            debug("WARNING: Occasion list in user defaults for key \(userDefaultsKey) is empty")
            return
        }
        
        var selectedOccasionsCount = 0
        
        for selectedRestoredName in selectedNamesRestored {
            guard let occasion = Occasion.all[selectedRestoredName.lowercased()] else { continue }
            occasion.isSelected = true
            selectedOccasionsCount += 1
        }
        
        debug(
            "\(userDefaultsKey): \(selectedNamesRestored.count) loaded,",
            "\(selectedOccasionsCount) of \(Occasion.all.count) selected"
        )
    }
    
    /// Save selected occasion names to user defaults
    static func saveSelectedOccasions() {
        let selectedNamesLowercased = self.selectedNames.map { $0.lowercased() }
        UserDefaults.standard.set(selectedNamesLowercased, forKey: Occasion.userDefaultsKey)
    }
}
