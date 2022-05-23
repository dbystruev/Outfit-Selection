//
//  PickType.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 28.09.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

/// There are 3 sectionType of feed cell so far
enum PickType: Codable {
    // MARK: - Computed Static Properties
    static var primary: [PickType] {
        [.brands, .newItems, .sale]
    }
    
    // MARK: - Enum
    case brand(String) // New arrivals for [brand]
    case brands
    case category(String) // [caregory] lover 30
    case collections(String)
    case daily(Int) // Daily 30
    case emptyBrands
    case hello // Hello, *user name*
    case newItems
    case occasion(String) // Your personalized pick for [occasion]
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
        case .occasion(let occasion): //
            return "Your personalized pick for"~ + " \(occasion)"
        case .category(let category):
            return "\(category) " + "lover"~
        case .collections(let name):
            return name
        case .daily(let limit):
            return "Daily"~ + " \(limit)"
        case .emptyBrands:
            return "Please select your favourite brands"~
        case .hello:
            guard let userName = User.current.displayName else { return nil }
            return "Hello"~ + ", \(userName)"
        case .newItems:
            return "New items for you"~
        case .occasions(let id):
            guard let occasion = Occasions.byID[id] else { return nil }
            return occasion.title
        case .sale:
            return "Sales"~
        }
    }
    /// Subtitle in feed collection section
    var subtitle: [String]? {
        switch self{
        case .brand(_):
            return nil
        case .brands:
            return nil
        case .occasion(_):
            return nil
        case .category(_):
            return nil
        case .collections(_):
            return nil
        case .daily(_):
            return nil
        case .emptyBrands:
            return nil
        case .hello:
            return ["We picked up items for you"~, "Based on your preferences and lifestyle"~]
        case .newItems:
            return ["Daily updated"~]
        case .occasions(_):
            return nil
        case .sale:
            return nil
        }
    }
}

extension PickType: Equatable {}
extension PickType: Hashable {}
