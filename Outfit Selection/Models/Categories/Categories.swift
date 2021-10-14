//
//  Categories.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 14.10.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

typealias Categories = [Category]

extension Categories {
    // MARK: - Stored Static Properties
    /// The full  list of categories
    static var all: [Category] = [] {
        didSet {
            all.forEach { byId[$0.id] = $0 }
            debug("INFO: updated to \(all.count) values")
        }
    }
    
    /// The list of categories by id
    private(set) static var byId: [Int: Category] = [:]
    
    /// Female categories filtered by chosen female category names
    static let femaleCategories: [[Category]] = {
        femaleCategoryNames.map { words in
            all.filter { category in
                let categoryName = category.name.lowercased()
                return words.contains { categoryName.contains($0) }
            }
        }
    }()
    
    /// Female category names
    static let femaleCategoryNames: [[String]] = [
        // Top left
        ["топы"],
        
        // Bottom left
        ["брюки", "деним", "юбки"],
        
        // Top right
        ["куртки", "пиджаки", "пальто", "свитеры", "трикотаж"],
        
        // Middle right
        ["клатчи", "колье", "ожерелья", "кольца", "маски", "серьги", "сумки"],
        
        // Bottom right
        ["ботинки", "мюли", "сапоги", "туфли"],
    ]
    
    /// Male categories filtered by chosen male category names
    static let maleCategories: [[Category]] = {
        maleCategoryNames.map { words in
            all.filter { category in
                let categoryName = category.name.lowercased()
                return words.contains { categoryName.contains($0) }
            }
        }
    }()
    
    /// Male category names
    static let maleCategoryNames: [[String]] = [
        // Top left
        ["футболки", "майки"],
        
        // Bottom left
        ["брюки", "деним"],
        
        // Top right
        ["куртки", "пиджаки", "пальто", "рубашки", "трикотаж"],
        
        // Middle right
        ["головные", "уборы", "маски"],
        
        // Bottom right
        ["броги", "оксфорды", "лоферы", "сапоги"],
    ]
    
    /// The maximum number of items in one corner, all of them displayed
    static let maxCornerCount = 100
    
    // MARK: - Static Methods
    /// Return the list of the category lists filtered by gender
    /// - Parameter gender: gender to filter categories by
    /// - Returns: the list of the category lists filtered by gender
    static func filtered(by gender: Gender?) -> [[Category]] {
        switch gender {
        case .female:
            return femaleCategories
        case .male:
            return maleCategories
        case .other, nil:
            return femaleCategories + maleCategories
        }
    }
    
    /// Return the list of categories filetered by given occasions
    /// - Parameter occasions: occasions to filter categories by
    /// - Returns: the list of categories filtered by occasions
    static func filtered(by occasions: [Occasion]) -> [Category] {
        occasions.flatMap({ $0.categoryIDs }).unique.compactMap { byId[$0] }
    }
}
