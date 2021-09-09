//
//  Occasion.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 09.09.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import Foundation

struct Occasion: Codable {
    
    // MARK: - Properties
    /// The name of the occasion
    let name: String
    
    /// Flag showing if occasion is selected by the user
    private var _isSelected = false
    
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
    
    // MARK: - Init
    /// Constructor for occasion
    /// - Parameters:
    ///   - name: the name of the occasion
    ///   - isSelected: whether the occasion is selected by the user, false by default
    init(_ name: String, isSelected: Bool = false) {
        self.name = name
        self.isSelected = isSelected
    }
}

// MARK: - UserDefaults
extension Occasion {
    // MARK: - Static Constants
    /// User defaults key
    static let userDefaultsKey = "GetOutfitSelectedOccasionsBrandsKey"
    
    // MARK: - Static Methods
    /// Load selected occasion names from user defaults and updated Occasion.all
    static func loadSelectedOccasions() {
        guard let selectedNames = UserDefaults.standard.object(forKey: Occasion.userDefaultsKey) as? [String] else { return }
        guard !selectedNames.isEmpty else { return }
        
        for (index, occasion) in Occasion.all.enumerated() {
            guard selectedNames.contains(occasion.name.lowercased()) else { continue }
            Occasion.all[index]._isSelected = true
        }
    }
    
    /// Save selected occasion names to user defaults
    static func saveSelectedOccasions() {
        let selectedNames = Occasion.all.compactMap { $0.isSelected ? $0.name.lowercased() : nil }
        UserDefaults.standard.set(selectedNames, forKey: Occasion.userDefaultsKey)
    }
}
