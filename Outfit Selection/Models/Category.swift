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
    static let all: [Category] = [
        Category(id: 136332, name: "Футболки и майки", parentId: 136330),
        Category(id: 136043, name: "Деним", parentId: 135967),
        Category(id: 136226, name: "Куртки", parentId: 135967),
        Category(id: 136311, name: "Рюкзаки", parentId: 135971),
        Category(id: 136310, name: "Кроссовки", parentId: 136301),
    ]
    
    // MARK: - Stored Properties
    /// Category identifier
    let id: Int
    
    /// Category name
    let name: String
    
    /// Parent's category identifier
    let parentId: Int?
}
