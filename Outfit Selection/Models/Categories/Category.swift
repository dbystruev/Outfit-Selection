//
//  Category.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 26.10.2020.
//  Copyright © 2020 Denis Bystruev. All rights reserved.
//

struct Category: Codable {    
    // MARK: - Stored Properties
    /// Category identifier
    let id: Int
    
    /// Category name
    let name: String
    
    /// Parent's category identifier
    let parentId: Int?
}

// MARK: - CustomStringConvertible
extension Category: CustomStringConvertible {
    var description: String {
        "\(id) \(name)"
    }
}
