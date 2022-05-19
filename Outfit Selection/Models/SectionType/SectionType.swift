//
//  SectionType.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 28.09.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

/// There are 3 sectionType of feed cell so far
enum SectionType {
    // MARK: - Computed Static Properties
    static var primary: [SectionType] {
        [.brands, .newItems, .sale]
    }
    
    // MARK: - Enum
    case brand(String) // New arrivals for [brand]
    case brands
    case categories(String) // Your personalized pick for [occasion]
    case category(String, Int) // [caregory] lover 30
    case collections(String)
    case daily(Int) // Daily 30
    case emptyBrands
    case newItems
    case occasions(Int)
    case sale
    
    // MARK: - Computed Properties
    /// Title in feed collection section
    var title: String? {
        switch self {
        case .brand(let brand): 
            return "New arrivals for"~ + " \(brand)"
        case .brands:
            return "Favourite brands"~
        case .categories(let occasion): //
            return "Your personalized pick for"~ + " \(occasion)"
        case .category(let category, let limit):
            return "\(category) " + "lover"~ + " \(limit)"
        case .collections(let name):
            return name
        case .daily(let limit):
            return "Daily"~ + " \(limit)"
        case .emptyBrands:
            return "Please select your favourite brands"~
        case .newItems:
            return "New items for you"~
        case .occasions(let id):
            guard let occasion = Occasions.byID[id] else { return nil }
            return occasion.title
        case .sale:
            return "Sales"~
        }
    }
}

extension SectionType: Equatable {}
extension SectionType: Hashable {}
