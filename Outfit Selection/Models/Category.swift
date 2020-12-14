//
//  Category.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 26.10.2020.
//  Copyright © 2020 Denis Bystruev. All rights reserved.
//

struct Category: Codable {
    // MARK: - Static Properties
    /// All categories to load from the server, must match the number of scroll views in outfit view controller's scroll views
    static let all: [[Category]] = [
        [Category(id: 136332, name: "Футболки и майки", parentId: 136330)],
        [Category(id: 136043, name: "Деним", parentId: 135967)],
        [Category(id: 136226, name: "Куртки", parentId: 135967)],
        [Category(id: 136311, name: "Рюкзаки", parentId: 135971)],
        [Category(id: 136310, name: "Кроссовки", parentId: 136301)],
    ]
    
    /// Female categories
    static let female: [[String]] = [
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
    
    /// Male categories
    static let male: [[String]] = [
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
    
    /// The maximum number of items in one category, all of them displayed
    static let maxItemCount = 25
    
    // MARK: - Stored Properties
    /// Category identifier
    let id: Int
    
    /// Category name
    let name: String
    
    /// Parent's category identifier
    let parentId: Int?
}
