//
//  Category.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 26.10.2020.
//  Copyright © 2020 Denis Bystruev. All rights reserved.
//

struct Category: Codable {
    // MARK: - Stored Static Properties
    /// The full  list of categories
    static var all: [Category] = [] {
        didSet {
            debug("INFO: updated to \(all.count) values")
        }
    }
    
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
    
    // MARK: - Stored Properties
    /// Category identifier
    let id: Int
    
    /// Category name
    let name: String
    
    /// Parent's category identifier
    let parentId: Int?
}
