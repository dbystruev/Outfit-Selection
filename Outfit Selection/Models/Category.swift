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
    
    /// Female category names
    static let femaleNames: [[String]] = [
        // Top left
        ["Топы"],
        
        // Bottom left
        ["Брюки", "Деним", "Юбки"],
        
        // Top right
        ["Куртки и пиджаки", "Пальто", "Свитеры и трикотаж"],
        
        // Middle right
        ["Клатчи", "Колье", "Колье и ожерелья", "Кольца", "Маски", "Серьги", "Сумки", "Сумки-тоут", "Сумки на плечо"],
        
        // Bottom right
        ["Ботинки на шнурках", "Мюли", "Сапоги", "Туфли-лодочки"],
    ]
    
    /// Male category names
    static let maleNames: [[String]] = [
        // Top left
        ["Футболки и майки"],
        
        // Bottom left
        ["Брюки", "Деним"],
        
        // Top right
        ["Куртки", "Куртки и пиджаки", "Пальто", "Рубашки", "Трикотаж"],
        
        // Middle right
        ["Головные уборы", "Маски"],
        
        // Bottom right
        ["Броги", "Броги и оксфорды", "Лоферы", "Сапоги"],
    ]
    
    /// The maximum number of items in one corner, all of them displayed
    static let maxCornerCount = 100
    
    // MARK: - Computed Static Properties
    /// Female categories filtered by chosen female category names
    static var female: [[Category]] {
        femaleNames.map { categoryNames in
            let categoryNamesLowerased = categoryNames.map { $0.lowercased() }
            return all.filter { category in
                categoryNamesLowerased.contains(category.name.lowercased())
            }
        }
    }
    
    /// Male categories filtered by chosen male category names
    static var male: [[Category]] {
        maleNames.map { categoryNames in
            let categoryNamesLowerased = categoryNames.map { $0.lowercased() }
            return all.filter { category in
                categoryNamesLowerased.contains(category.name.lowercased())
            }
        }
    }
    
    // MARK: - Static Methods
    /// Return the list of the category lists filtered by gender
    /// - Parameter gender: gender to filter categories by
    /// - Returns: the list of the category lists filtered by gender
    static func filtered(by gender: Gender?) -> [[Category]] {
        switch gender {
        case .female:
            return female
        case .male:
            return male
        case .other, nil:
            return female + male
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
