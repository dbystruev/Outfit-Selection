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
    static var all: Categories = [] {
        didSet {
            all.forEach { byID[$0.id] = $0 }
        }
    }
    
    /// The list of categories by id
    private(set) static var byID: [Int: Category] = [:]
    
    /// Female categories filtered by chosen female category names
    static let female: [Categories] = {
        femaleNames.map { words in
            all.filter { category in
                let categoryName = category.name.lowercased()
                return words.contains { categoryName.contains($0) }
            }
        }
    }()
    
    /// Female category names
    static let femaleNames: [[String]] = [
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
    static let male: [Categories] = {
        maleNames.map { words in
            all.filter { category in
                let categoryName = category.name.lowercased()
                return words.contains { categoryName.contains($0) }
            }
        }
    }()
    
    /// Male category names
    static let maleNames: [[String]] = [
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
    /// Return the generated list of the category lists by gender
    /// - Parameter gender: gender to filter categories by
    /// - Returns: the list of the category lists filtered by gender
    static func by(gender: Gender?) -> [Categories] {
        switch gender {
        case .female:
            return female
        case .male:
            return male
        case .other, nil:
            return female + male
        }
    }
    
    /// Return the list of subcategory lists from the given occasions
    /// - Parameter occasions: the occasions to generate the list of subcategories from
    /// - Returns: the list of subcategories from occasions
    static func by(occasions: Occasions) -> [Categories] {
        // Occasions -> corners -> subcategories
        var subcategoryIDs = [[Int]](repeating: [], count: Corner.allCases.count)
        
        // Append subcategory IDs for corresponding corners of each occasion
        for occasion in occasions {
            let subcategoryIDsByCorners = occasion.corners
            for cornerIndex in 0 ..< Swift.min(subcategoryIDs.count, subcategoryIDsByCorners.count) {
                subcategoryIDs[cornerIndex].append(contentsOf: subcategoryIDsByCorners[cornerIndex])
            }
        }
        
        // Remove doubles in subcategory IDs
        for cornerIndex in 0 ..< subcategoryIDs.count {
            subcategoryIDs[cornerIndex] = subcategoryIDs[cornerIndex].unique
        }
        
        // Map IDs into categories and reorder them from occasions
        return subcategoryIDs.map { $0.categories }.corners(.occasions)
    }
    
    // MARK: - Computed Properties
    /// IDs of categories
    var IDs: [Int] { map { $0.id }}
    
    // MARK: - Custom Methods
    /// Reorder the categories by given corners
    /// - Parameter corners: the corners to reorder the categories by
    /// - Returns: the reordered categories
    func corners(_ corners: Corners) -> Categories {
        corners.compactMap {
            self[safe: $0.rawValue]
        }
    }
    
    /// Return the list of categories filtered by given occasions
    /// - Parameter occasions: occasions to filter categories by
    /// - Returns: the list of categories filtered by occasions
    func filtered(by occasions: Occasions) -> Categories {
        let uniqueCategoryIDs = occasions.flatMap({ $0.corners }).flatMap({ $0 }).unique
        return filter { uniqueCategoryIDs.contains($0.id) }
    }
}
