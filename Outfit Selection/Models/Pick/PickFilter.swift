//
//  PickFilter.swift
//  Outfit Selection
//
//  Created by Evgeniy Goncharov on 23.05.2022.
//  Copyright © 2022 Denis Bystruev. All rights reserved.
//

import Foundation

enum PickFilter: String, Codable {
    case additionalBrands // Filter by additional (relevant) brands
    case brand // Filter by one brand
    case brands // Filter by all selected brands
    case category // Filter by one category in all selected occasions
    case daily // Pick last day items
    case excludeBrands // Exclude all selected brands
    case gender // Filter by current gender
    case occasion // Filter by all categories in one occasion
    case occasions // Filter by all selected occasions
    case random // Shuffle items before applying limit
    case sale // Keep only items on sale
    
    // MARK: - Types
    enum CodingKeys: String, CodingKey {
        case additionalBrands = "additional_brands"
        case brand
        case brands
        case category
        case daily
        case excludeBrands = "exclude_brands"
        case gender
        case occasion
        case occasions
        case random
        case sale
    }
}
